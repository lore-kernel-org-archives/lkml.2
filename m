Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1FJRvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:51:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56383 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab1FJRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MyhWJCg+7eMzKMk04sP8DbViakChbtfSt41+sfoWsypeB+8phv4tOgpCtmgqmYScg1
         TscZbZdS6n6vf0E38LQdDvIVs3SY02yvvo/r18q98bEe8ycSzX+ZH8RlJW/Sma6smWxy
         F8A2HQ6o0JxcZFxEFyzdRYWroRtkyzuXlLtXU=
Message-ID: <4DF259B2.9070403@gmail.com>
Date: Fri, 10 Jun 2011 19:51:46 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org>
In-Reply-To: <20110610164706.GB25774@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well,

Op 10-06-11 18:47, Matthew Garrett schreef:
> So this is obviously even more of a hack, but before you check whether 
> the memblock has already been reserved could you __check_region it as 
> well? That ought to avoid us touching the kernel. I've got a patch for 
> grub that'll avoid the situation where we load the kernel on top of an 
> existing resource and I'll port that to grub2, but that's still going to 
> be awkward for existing bootloaders.
>
Erm, __check_region calls __requestion_region which does a kzalloc,
if I call __check_region it doesn't boot, probably because of that.

Do you want me to manually run through iomem_resource? Is it even available up at that point?

~Maarten
