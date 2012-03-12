Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2CLMGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2CLMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:05:58 -0400
Message-ID: <4F5DE6A4.2030303@redhat.com>
Date: Mon, 12 Mar 2012 13:05:56 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
References: <4F5A3A4D.1020008@redhat.com> <20120309172934.GA18173@host2.jankratochvil.net>
In-Reply-To: <20120309172934.GA18173@host2.jankratochvil.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 06:29 PM, Jan Kratochvil wrote:
> On Fri, 09 Mar 2012 18:13:49 +0100, Denys Vlasenko wrote:
>> gdb retrieves loaded library names by examining dynamic loader's
>> data stored in the coredump's data segments. It uses intimate
>> knowledge how and where dynamic loader keeps the list of loaded
>> libraries.
>
> this is the backward compatible way and it is no longer the right one with
> build-ids.
 >
 > GDB should scan the address space for mapped build-ids and map symbol files
 > accordingly.

Build-ids are useful, but they still don't map directly to the names
of loaded files. You need to rely on /usr/lib/debug/.build-id/XX/YYYYYYYYYY
symlinks to translate build-ids to names.

For example, on my home machine (linux-from-scratch style) I don't have
/usr/lib/debug/.build-id/* directory at all. So build-ids can't be used
to find the binary and libraries there.

Why we don't save library names in coredump? I see no logical reason
not to do so. Even if those names sometimes won't be reliable
("deleted files" problem), it's not a good reason to shoot ourself
in the food and deprive ourself from this information 100% of the time.


>> Another question is detection of deleted files.
>> If /usr/lib/xulrunner-2/libmozjs.so was updated while program ran
>> and now file mapped into process address space does not correspond
>> to the same-named file on disk, can we help users to detect this? How?
>> By saving maj/min/inode? Hash thereof?
>> File size?
>> File's md5sum (probably not, way too expensive. But nicely robust...)?
>
> build-id is already being saved.  This is all that matters.  Filename does not
> say anything - as you noticed it can be even already deleted,

Yes, the file can be deleted/updated-via-rename. That's the case
I want to be possible to detect.

> it can have unknown content etc.

I don't understand. *What* can have unknown content?

 > I do not see what problems you target here.

I'm thinking whether we should supply some mechanism for detecting
"deleted/updated file" problem. Even if this would be a heuristic.
I'll be satisfied with 99.9999% success rate instead of 100% :)

-- 
vda
