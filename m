Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2LJAKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 19:10:25 -0500
Received: from ozlabs.org ([203.10.76.45]:44790 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab2LJAKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 19:10:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/5] kbuild: silence rule for extra_certificates
In-Reply-To: <20121209165425.GA29331@pobox.suse.cz>
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net> <1353269117-39917-2-git-send-email-pefoley2@verizon.net> <20121209165425.GA29331@pobox.suse.cz>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 10 Dec 2012 10:38:38 +1030
Message-ID: <87d2yiepkp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:
> Added David and Rusty.
>
> On Sun, Nov 18, 2012 at 03:05:14PM -0500, pefoley2@verizon.net wrote:
>> From: Peter Foley <pefoley2@verizon.net>
>> 
>> Silence the touch extra_certificates command
>> 
>> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>
> I think we should tell the user that the default empty extra
> certificates list is being used, in case the user used a wrong filename
> or similar. How about this?

I prefer this one... Peter?

Thanks,
Rusty.

>
> Subject: MODSIGN: Fix kbuild output when using default extra_certificates
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 0dfeca4..8c708e4 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -136,8 +136,12 @@ ifeq ($(CONFIG_MODULE_SIG),y)
>  #
>  # Pull the signing certificate and any extra certificates into the kernel
>  #
> +
> +quiet_cmd_touch = TOUCH   $@
> +      cmd_touch = touch   $@
> +
>  extra_certificates:
> -	touch $@
> +	$(call cmd,touch)
>  
>  kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
>  
> But I don't insist on the above, feel free to hide the command
> completely.
>
> Michal
>
>> ---
>>  kernel/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kernel/Makefile b/kernel/Makefile
>> index 86e3285..18a0b61 100644
>> --- a/kernel/Makefile
>> +++ b/kernel/Makefile
>> @@ -137,7 +137,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
>>  # Pull the signing certificate and any extra certificates into the kernel
>>  #
>>  extra_certificates:
>> -	touch $@
>> +	@touch $@
>>  
>>  kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
>>  
>> -- 
>> 1.8.0
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
