Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0D1NHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:07:37 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47662 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0D1NHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mjR2hLW8E9Xvm/QKUaqCkiYWW6FDRT8AHZ67jrlCoZC9xMHHd1IVa8LFOZOmeMi6zC
         Vavaulovf9fkEJTED+mrA7de975bXBCst+HIF3IXNse9BBObbpjzivdfuk5t27yY0Knx
         JA8xEW+V7P/UvZ+kMGU0OBa7KEOCIHjNhQu7M=
MIME-Version: 1.0
In-Reply-To: <x2qac3eb2511004280123gd6143cd3ge641825089865172@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
	 <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
	 <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
	 <1272295140.2434.8.camel@yio.site>
	 <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
	 <s2yac3eb2511004270505g4ded10f5k5322850e8b58790f@mail.gmail.com>
	 <1272372187.5484.3981.camel@macbook.infradead.org>
	 <r2iac3eb2511004270634q31ad5aa2ne5f6de21355f1a36@mail.gmail.com>
	 <x2qac3eb2511004280123gd6143cd3ge641825089865172@mail.gmail.com>
Date: Wed, 28 Apr 2010 16:07:34 +0300
Message-ID: <g2m1ba2fa241004280607n2e234e1dj1ea37cfb609f8787@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
From: Tomas Winkler <tomasw@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Woodhouse <dwmw2@infradead.org>, dhowells@redhat.com,
       Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:23 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Apr 27, 2010 at 15:34, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Tue, Apr 27, 2010 at 14:43, David Woodhouse <dwmw2@infradead.org> wrote:
>>> This untested patch attempts to put the page array into the 'struct
>>> firmware' so that we can free it from release_firmware().
>>
>> Looks good. Seems to work without problems and without leaking memory.
>>
>> Misses only the member in the struct firmware though. :)
>
> Thomas, any chance to test David's patch, if that solves the issues you've seen?
>
> Just add the missing line:
>
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -12,6 +12,7 @@
>  struct firmware {
>        size_t size;
>        const u8 *data;
> +       struct page **pages;
>  };
>
>
In progress. Will post results later today (timezone:GMT+2)

Thanks
Tomas
