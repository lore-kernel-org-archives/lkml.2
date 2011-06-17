Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1FQDdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:33:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38518 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab1FQDdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:33:14 -0400
X-AuditID: b753bd60-a46b0ba0000019f4-0a-4dfacaf7c33e
X-AuditID: b753bd60-a46b0ba0000019f4-0a-4dfacaf7c33e
Message-ID: <4DFACAF1.3010300@hitachi.com>
Date: Fri, 17 Jun 2011 12:33:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de,
        stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
In-Reply-To: <20110616161442.GA32113@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/17 1:14), Greg KH wrote:
> On Thu, Jun 16, 2011 at 11:50:54AM -0400, James Bottomley wrote:
>>> And again, why not just fix the userspace tools?  That is trivial to do
>>> so and again, could have been done by now in the years this has been
>>> discussed.
>>
>> So I can summarise where I think we are in these discussions:
>>
>> We provide the ability to give all kernel devices a "preferred name".
>> By default this will be the device name the kernel would have originally
>> assigned.  the dev_printk's will use the preferred name, and it will be
>> modifiable from user space.  All the kernel will do is print out
>> whatever it is ... no guarantees of uniqueness or specific format will
>> be made.  Since we're only providing one preferred_name file, the kernel
>> can only have one preferred name for a device at any given time
>> (although it is modifiable on the fly as many times as the user
>> chooses).
>>
>> The design is to use this preferred name to implement what Hitachi wants
>> in terms of persistent name, but we don't really care.
>>
>> All userspace naming will be taken care of by the usual udev rules, so
>> for disks, something like /dev/disk/by-preferred/<fred> which would be
>> the usual symbolic link.
> 
> No, udev can not create such a link after the preferred name is set, as
> it has no way of knowing that the name was set.
> 
>> This will ensure that kernel output and udev input are consistent.  It
>> will still require that user space utilities which derive a name for a
>> device will need modifying to print out the preferred name.
> 
> It also doesn't solve the issue of userspace wanting to use such a
> "preferred" name in the command line of tools, as there will not be a
> link back to the "kernel" name directly in /dev/.

Right, this series just add a preferred name interface, and changes
a part of kernel messages.

> So as userspace tools will still need to be fixed, I don't see how
> adding a kernel file for this is going to help any.  Well, a bit in that
> the kernel log files will look "different", but again, that really isn't
> a problem that userspace couldn't also solve with no kernel changes
> needed.

hmm, He didnt say "this can solve all problems". I think
preferred name is just a starting point to solve these problems.
Actually, he decided to fix those user space tools to accept
persistent symbolic links, and to show it in outputs.

It's not complete, but a good starting point, isn't it?

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
