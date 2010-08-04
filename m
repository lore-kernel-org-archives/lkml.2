Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0HDH7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:59:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab0HDH7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:59:02 -0400
Message-ID: <4C591DCC.7080104@kernel.org>
Date: Wed, 04 Aug 2010 09:59:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to hd_structs
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> <1280887483-2979-2-git-send-email-wad@chromium.org>
In-Reply-To: <1280887483-2979-2-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 07:58:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/04/2010 04:04 AM, Will Drewry wrote:
>  struct partition_meta_info {
>  	enum partition_meta_info_format_t format;
>  	union {
> +#ifdef CONFIG_EFI_PARTITION
> +		struct {
> +			efi_guid_t uuid;
> +			efi_guid_t type;
> +			efi_char16_t label[72 / sizeof(efi_char16_t)];
> +		} efi;
> +#endif

It would be nice if uuid can be made a common field outside of the
union so that generic code which only cares about UUID can simply read
it off.

Thanks.	

-- 
tejun
