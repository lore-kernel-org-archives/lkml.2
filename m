Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0DGBru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:47:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36214 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab0DGBrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f1bkx7Pv7vnaFW16WaEOzMaqyXr9f95F+FuIQorXh70A1LTpzNSeLlR9G6wXHAcyz9
         USdJ02eM+bZQzC3LZ/lGUw0OU3+FDCdGety8OsYfBPa5llldYeqtK7ML+FlqsmMc8lob
         xx8H5zABofqVWXjnYtmub8Sky82Nir8+fjxIo=
MIME-Version: 1.0
In-Reply-To: <4BBBC470.4050002@zytor.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	 <4BBB7AC9.5060008@zytor.com>
	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
	 <4BBB8F07.60401@zytor.com>
	 <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com>
	 <q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com>
	 <3715922601579231267@unknownmsgid> <4BBBC470.4050002@zytor.com>
Date: Tue, 6 Apr 2010 20:47:44 -0500
Message-ID: <q2he6bf505b1004061847l31b2fe15v31d1556862d3a2f9@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Youngwhan Song <breadncup@gmail.com>,
       Venkatram Tummala <venkatram867@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the last 128MB out of the kernel 1GB space is used to for highmen,
meanwhile it's also used for IO/vmalloc, how does this work?

Xianghua

On Tue, Apr 6, 2010 at 6:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/06/2010 04:27 PM, Youngwhan Song wrote:
>> Nice explanation, Venkatram,
>>
>> Just one question pop up mind.
>>
>> What if actual physical memory is only 256MB? How does kernel divide
>> virtual memory? Do we need to specify the region to kernel? Or will
>> kernel itself decide it automatically?
>>
>
> If there is less than 896 MB of physical memory, the vmalloc region is
> automatically extended (in your case, it will be 768 MB in size.)  There
> will be no HIGHMEM in such a case, and if you are compiling your own
> kernel you will gain considerable speed by disabling HIGHMEM support
> completely.
>
> This, of course, was the norm back when Linux was first created, and a
> typical amount of memory was 8 MB or so.  That we'd have gigabytes of
> memory seemed very distant at the time.
>
>        -hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
