Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0GLThn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:37:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48564 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0GLThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=amU1ULUhci52fDsuRYChJoIsmu2GnC6Gn+IHY//S0hTEsfZzA8ZCGo2iXn/BO0B3hQ
         Jhs7FpD5+ObhSKGgcCyH7lrIXeHVh6MCLx1oqUnS4sCnfjVtGO/uo8HpCrYqqh98QvM7
         E/qQ2PJM5WDUdxbt//LNXJJoyaqegC3mloJfI=
Message-ID: <4C3B6F03.8060708@lwfinger.net>
Date: Mon, 12 Jul 2010 14:37:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive from checkpatch.pl
References: <4C3B5660.8020405@lwfinger.net>	 <1278959315.1501.261.camel@Joe-Laptop.home> <4C3B608B.9010501@lwfinger.net> <1278961381.1501.284.camel@Joe-Laptop.home>
In-Reply-To: <1278961381.1501.284.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 02:03 PM, Joe Perches wrote:
> On Mon, 2010-07-12 at 13:35 -0500, Larry Finger wrote:
>> These are ugly macros that will be eliminated, but for the moment they are in
>> the code. As I stated in my original email, removing the comma from the
>> definition and adding it to the code does fix the checkpatch error, but it
>> should not be necessary.
>
> Hi Larry.
>
> Using checkpatch is not necessary.
>
> If you want generally conforming kernel style,
> the macro should not end in a trailing comma.
>
> Feel free to ignore the checkpatch message,
>
> I think the warning is reasonable, though it
> could be made more specific.
>
> cheers, Joe
>
> Maybe something like:
> ---
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bd88f11..7e8a3f4 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2394,8 +2394,10 @@ sub process {
>   			}x;
>   			#print "REST<$rest>  dstat<$dstat>\n";
>   			if ($rest ne '') {
> -				if ($rest !~ /while\s*\(/&&
> -				    $dstat !~ /$exceptions/)
> +				if ($rest eq ",") {
> +					ERROR("Macros should not end with a trailing comma\n" . "$here\n$ctx\n");
> +				} elsif ($rest !~ /while\s*\(/&&
> +					 $dstat !~ /$exceptions/)
>   				{
>   					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
>   			}

That looks good. At least it makes clear what is wrong.

Should it be an error, or just a warning?

Larry
