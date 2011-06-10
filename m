Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab1FJXWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:22:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49645 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab1FJXWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lnidFlA+cKlJpHB1sKhyUEVEmv288II/fO2crzMTYlgLW26oLkRV5gXiymoGZ1j3Ej
         u7IGp79iSeeJDmPdb1W/E3aKsBbbV0X47Is7Alaq04xV0H5WhM6kT/04qowshBhzfumX
         9g7VKsy7yLE4GRH39JXehhI0hDGL42RwOZpfU=
Message-ID: <4DF2A749.9050301@gmail.com>
Date: Sat, 11 Jun 2011 01:22:49 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <4DF2A17E.7000103@kernel.org> <20110610230359.GA2084@srcf.ucam.org> <20110610231721.GA18608@suse.de>
In-Reply-To: <20110610231721.GA18608@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Op 11-06-11 01:17, Greg KH schreef:
> On Sat, Jun 11, 2011 at 12:03:59AM +0100, Matthew Garrett wrote:
>> On Fri, Jun 10, 2011 at 03:58:06PM -0700, Yinghai Lu wrote:
>>
>>> the problem is : overlapping between kernel code with boot services code.
>> SHouldn't checking against the iomem resource map avoid that?
>>
>>> now e820 table that is passed from bootloader do not include boot services code range. and also current boot/head_64.S will not
>>> try to find usable range for decompressed kernel ( too early )...
>>>
>>> So solution will be:
>>> 1. revert Matthew Garrett's patch, because it breaking unknown good platform.
>> That's acceptable if we can't find a better solution.
> If no one objects, I'd like to revert the EFI patch that went into
> 2.6.39.1 that is causing people problems so as to give everyone some
> time to get 3.0 working properly on these boxes.
Seems we don't have a proper fix yet, so reverting is fine, pulling the consolidate NX patch
would still give the problem of overlapping pages in mainline, there appears to be no solution yet.
Reverting the change would make vanilla stable boot on my system again at least.

~Maarten
