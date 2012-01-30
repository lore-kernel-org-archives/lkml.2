Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2A3GE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 01:04:29 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:34314 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2A3GE2 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 30 Jan 2012 01:04:28 -0500
Message-ID: <4F2632C7.2000203@suse.com>
Date: Mon, 30 Jan 2012 11:33:51 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Slab corruption in floppy driver module
References: <4F1EAFE9.5000306@suse.com> <20120124223153.GG17291@redhat.com> <20120126150420.GD1891@redhat.com> <20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com> <20120126193735.GA11297@redhat.com> <giobtq5e46.fsf@mx10.gouders.net> <4F223F11.4050307@suse.com> <giaa59tmbr.fsf@mx10.gouders.net> <20120127195455.GA18068@redhat.com> <20120129193601.GD17211@htj.dyndns.org>
In-Reply-To: <20120129193601.GD17211@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 01:06 AM, Tejun Heo wrote:
> On Fri, Jan 27, 2012 at 02:54:55PM -0500, Vivek Goyal wrote:
>> floppy: Fix a crash during rmmmod
>>
>> floppy driver does not call add_disk() on all the drives hence we don't take
>> gendisk reference on request queue for these drives. Don't call put_disk()
>> with disk->queue set, otherwise we try to put the reference we never took.
>>
>> Reported-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> 
>> Signed-off-by: Vivek Goyal<vgoyal@redhat.com>
> 
> Ugh... floppy init is ugly.  Thanks for fixing this.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> Jens, this one and the previous one are regression fixes and need to
> be routed through v3.3-fixes.
> 

Looks like it needs to be marked for -stable as well as the commit
f992ae8 which exposed these problems was originally marked for -stable?


Suresh
