Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab2JKQcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:32:50 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:56667 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab2JKQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <m2fw5mtffg.fsf_-_@firstfloor.org>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
From: =?UTF-8?B?5p2o6IuP56uLIFlhbmcgU3UgTGk=?= <suli@cs.wisc.edu>
Date: Thu, 11 Oct 2012 11:32:27 -0500
X-Google-Sender-Auth: -5-ERIeZRi9hyeUBe3YQLugYDuc
Message-ID: <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
Subject: Re: [sqlite] light weight write barriers
To: General Discussion of SQLite Database <sqlite-users@sqlite.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, drh@hwaci.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not quite whether I should ask this question here, but in terms
of light weight barrier/fsync, could anyone tell me why the device
driver / OS provide the barrier interface other than some other
abstractions anyway? I am sorry if this sounds like a stupid questions
or it has been discussed before....

I mean, most of the time, we only need some ordering in writes; not
complete order, but partial,very simple topological order. And a
barrier seems to be a heavy weighted solution to achieve this anyway:
you have to finish all writes before the barrier, then start all
writes issued after the barrier. That is some ordering which is much
stronger than what we need, isn't it?

As most of the time the order we need do not involve too many blocks
(certainly a lot less than all the cached blocks in the system or in
the disk's cache), that topological order isn't likely to be very
complicated, and I image it could be implemented efficiently in a
modern device, which already has complicated caching/garbage
collection/whatever going on internally. Particularly, it seems not
too hard to be implemented on top of SCSI's ordered/simple task mode?
(I believe Windows does this to an extent, but not quite sure).

Thanks a lot

Suli


On Wed, Oct 10, 2012 at 12:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Richard Hipp writes:
>>
>> We would really, really love to have some kind of write-barrier that is
>> lighter than fsync().  If there is some method other than fsync() for
>> forcing a write-barrier on Linux that we don't know about, please enlighten
>> us.
>
> Could you list the requirements of such a light weight barrier?
> i.e. what would it need to do minimally, what's different from
> fsync/fdatasync ?
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
> _______________________________________________
> sqlite-users mailing list
> sqlite-users@sqlite.org
> http://sqlite.org:8080/cgi-bin/mailman/listinfo/sqlite-users
