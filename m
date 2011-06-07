Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1FGMWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:22:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56085 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1FGMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lgIIJzsBVx+NAsG2J4BO/253Um2TJtjzOuLi/E/h72b4aWhUvSG2k5rz8/jk5SB78w
         PrTGRKu0kT6dPR914ccR9n/WljPlAYN339T87AI8sPwKjhfgbkkpk1TmKwPFOB9p2SAT
         6Za07pycZxyQD9JCEQVBPEn985EUHiDahyq/c=
Message-ID: <4DEE17F9.6020503@gmail.com>
Date: Tue, 07 Jun 2011 14:22:17 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com>
In-Reply-To: <4DEDEA73.7010900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-06-11 11:08, Maarten Lankhorst schreef:
> Hi,
>
> Op 07-06-11 04:05, Yinghai Lu schreef:
>> On 06/06/2011 06:41 PM, Matthew Garrett wrote:
>>> On Mon, Jun 06, 2011 at 05:19:17PM -0700, Yinghai Lu wrote:
>>>
>>>> assume EFI in ram is not page-aligned?
>>> They'll be 4K aligned at least.
>>>
>> can you get boot log with "memblock=debug"?
> Well that definitely helped me isolate things. It seems some ranges are reserved already.
> I added a simple patch to ignore the reservations there. Just a proof of concept,
> don't rate for style. :-)
>
> @@ -334,6 +343,10 @@ static void __init efi_free_boot_services(void)
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;
>  
> +		/* Could not reserve boot area */
> +		if (size)
Oops.
> +			continue;
> +
>  		free_bootmem_late(start, size);
>  	}
>  }
>
>
It seems the error still occurs when calling free_bootmem_late
even if I only reserve blocks that haven't been reserved yet.

~Maarten
