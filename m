Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1BERe6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:34:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48281 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab1BERe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:34:57 -0500
Date: Sat, 5 Feb 2011 18:34:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        borislav.petkov@amd.com
Subject: Re: [PATCH 16/52] kstrtox: convert drivers/edac/
Message-ID: <20110205173449.GA31845@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, borislav.petkov@amd.com
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
 <1296915654-7458-16-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296915654-7458-16-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 05, 2011 at 04:20:19PM +0200, Alexey Dobriyan wrote:

Some kind of a boilerplate commit message is still better than none at all.

> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  drivers/edac/amd64_edac_inj.c |  135 +++++++++++++++++------------------------
>  drivers/edac/edac_mc_sysfs.c  |   20 +++---
>  drivers/edac/i7core_edac.c    |   41 +++++++------
>  drivers/edac/mce_amd_inj.c    |   28 ++++-----
>  4 files changed, 101 insertions(+), 123 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
> index 688478d..180a498 100644
> --- a/drivers/edac/amd64_edac_inj.c
> +++ b/drivers/edac/amd64_edac_inj.c
> @@ -16,21 +16,18 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
>  					  const char *data, size_t count)
>  {
>  	struct amd64_pvt *pvt = mci->pvt_info;
> -	unsigned long value;
> -	int ret = 0;
> -
> -	ret = strict_strtoul(data, 10, &value);
> -	if (ret != -EINVAL) {
> -
> -		if (value > 3) {
> -			amd64_warn("%s: invalid section 0x%lx\n", __func__, value);
> -			return -EINVAL;
> -		}
> -
> -		pvt->injection.section = (u32) value;
> -		return count;
> +	u32 value;
> +	int ret;
> +
> +	ret = kstrtou32(data, 10, &value);
> +	if (ret < 0)
> +		return ret;

newline here

> +	if (value > 3) {
> +		amd64_warn("%s: invalid section 0x%x\n", __func__, value);
> +		return -EINVAL;
>  	}

and here.

> -	return ret;
> +	pvt->injection.section = value;
> +	return count;
>  }
>  
>  static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
> @@ -49,21 +46,18 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
>  					const char *data, size_t count)
>  {
>  	struct amd64_pvt *pvt = mci->pvt_info;
> -	unsigned long value;
> -	int ret = 0;
> -
> -	ret = strict_strtoul(data, 10, &value);
> -	if (ret != -EINVAL) {
> -
> -		if (value > 8) {
> -			amd64_warn("%s: invalid word 0x%lx\n", __func__, value);
> -			return -EINVAL;
> -		}
> -
> -		pvt->injection.word = (u32) value;
> -		return count;
> +	u32 value;
> +	int ret;
> +
> +	ret = kstrtou32(data, 10, &value);
> +	if (ret < 0)
> +		return ret;

newline

> +	if (value > 8) {
> +		amd64_warn("%s: invalid word 0x%x\n", __func__, value);
> +		return -EINVAL;
>  	}

newline.

> -	return ret;
> +	pvt->injection.word = value;
> +	return count;
>  }
>  
>  static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
> @@ -81,22 +75,19 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
>  					     const char *data, size_t count)
>  {
>  	struct amd64_pvt *pvt = mci->pvt_info;
> -	unsigned long value;
> -	int ret = 0;
> -
> -	ret = strict_strtoul(data, 16, &value);
> -	if (ret != -EINVAL) {
> -
> -		if (value & 0xFFFF0000) {
> -			amd64_warn("%s: invalid EccVector: 0x%lx\n",
> +	u32 value;
> +	int ret;
> +
> +	ret = kstrtou32(data, 16, &value);
> +	if (ret < 0)
> +		return ret;

newline.

> +	if (value & 0xFFFF0000) {
> +		amd64_warn("%s: invalid EccVector: 0x%x\n",
>  				   __func__, value);
> -			return -EINVAL;
> -		}
> -
> -		pvt->injection.bit_map = (u32) value;
> -		return count;
> +		return -EINVAL;
>  	}
> -	return ret;

newline

> +	pvt->injection.bit_map = value;
> +	return count;
>  }
>  
>  /*
> @@ -107,29 +98,22 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
>  					const char *data, size_t count)
>  {
>  	struct amd64_pvt *pvt = mci->pvt_info;
> -	unsigned long value;
>  	u32 section, word_bits;
> -	int ret = 0;
> -
> -	ret = strict_strtoul(data, 10, &value);
> -	if (ret != -EINVAL) {

Dropping those would mean that the injection read (and write) below
would happen on any value written. Let's keep them and enforce a write
of '1' to be only valid injection trigger like the rest of the /sysfs
interfaces:

	ret = kstrtou8(data, 10, &value);
	if (ret < 0)
		return ret;

	if (value != 1)
		return -EINVAL;

>  
> -		/* Form value to choose 16-byte section of cacheline */
> -		section = F10_NB_ARRAY_DRAM_ECC |
> -				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> -		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
> +	/* Form value to choose 16-byte section of cacheline */
> +	section = F10_NB_ARRAY_DRAM_ECC |
> +		SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> +	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
>  
> -		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
> -						pvt->injection.bit_map);
> +	word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
> +			pvt->injection.bit_map);
>  
> -		/* Issue 'word' and 'bit' along with the READ request */
> -		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
> +	/* Issue 'word' and 'bit' along with the READ request */
> +	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
>  
> -		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
> +	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
>  
> -		return count;
> -	}
> -	return ret;
> +	return count;
>  }
>  
>  /*
> @@ -140,29 +124,22 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
>  					const char *data, size_t count)
>  {
>  	struct amd64_pvt *pvt = mci->pvt_info;
> -	unsigned long value;
>  	u32 section, word_bits;
> -	int ret = 0;
> -
> -	ret = strict_strtoul(data, 10, &value);
> -	if (ret != -EINVAL) {

Same as above.

>  
> -		/* Form value to choose 16-byte section of cacheline */
> -		section = F10_NB_ARRAY_DRAM_ECC |
> -				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> -		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
> +	/* Form value to choose 16-byte section of cacheline */
> +	section = F10_NB_ARRAY_DRAM_ECC |
> +		SET_NB_ARRAY_ADDRESS(pvt->injection.section);
> +	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
>  
> -		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
> -						pvt->injection.bit_map);
> +	word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
> +			pvt->injection.bit_map);
>  
> -		/* Issue 'word' and 'bit' along with the READ request */
> -		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
> +	/* Issue 'word' and 'bit' along with the READ request */
> +	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
>  
> -		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
> +	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
>  
> -		return count;
> -	}
> -	return ret;
> +	return count;
>  }
>  
>  /*
> @@ -197,17 +174,15 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
>  	{
>  		.attr = {
>  			.name = "inject_write",
> -			.mode = (S_IRUGO | S_IWUSR)
> +			.mode = S_IWUSR,

This change is not mentioned anywhere, why do we need it?

>  		},
> -		.show = NULL,
>  		.store = amd64_inject_write_store,
>  	},
>  	{
>  		.attr = {
>  			.name = "inject_read",
> -			.mode = (S_IRUGO | S_IWUSR)
> +			.mode = S_IWUSR,

ditto.

>  		},
> -		.show = NULL,
>  		.store = amd64_inject_read_store,
>  	},
>  };

Ok, provided the general change to kstrtoX is agreed upon, you can add
my Acked-by to the AMD EDAC changes pending the issues above.

Thanks.

-- 
Regards/Gruss,
    Boris.
