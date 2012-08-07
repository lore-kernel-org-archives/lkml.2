Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2HGOyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:54:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51851 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2HGOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:54:08 -0400
Message-ID: <50212C34.8030204@gmail.com>
Date: Tue, 07 Aug 2012 16:54:44 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mq: INFO: possible circular locking dependency detected
References: <501D0093.2090108@gmail.com> <20120806063433.GW23464@ZenIV.linux.org.uk>
In-Reply-To: <20120806063433.GW23464@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 08:34 AM, Al Viro wrote:
> On Sat, Aug 04, 2012 at 12:59:31PM +0200, Sasha Levin wrote:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest, using latest -next kernel, I've stumbled on the dump below.
>>
>> I think this is the result of commit 765927b2 ("switch dentry_open() to struct path, make it grab references itself").
> 
> 	Not quite, actually - back then the order didn't matter;
> unfortunately, I'd missed that place when porting Jan's series,
> which made these ordered.
> 
> 	Anyway, see today's vfs.git#for-linus; that should be dealt with
> there.
> 

Yup, that did it.
