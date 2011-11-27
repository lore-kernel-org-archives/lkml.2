Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1K0K1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab1K0K1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:27:38 -0500
Message-ID: <4ED2108F.9000203@redhat.com>
Date: Sun, 27 Nov 2011 11:27:27 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: NeilBrown <neilb@suse.de>, Cong Wang <amwang@redhat.com>,
        linux-raid@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 17/62] md: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-18-git-send-email-amwang@redhat.com> <20111127170013.20d180a9@notabene.brown>
In-Reply-To: <20111127170013.20d180a9@notabene.brown>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 07:00 AM, NeilBrown wrote:
> On Sun, 27 Nov 2011 13:26:57 +0800 Cong Wang <amwang@redhat.com> wrote:
> 
>>
>> Signed-off-by: Cong Wang <amwang@redhat.com>
> 
> This and patch 57/62
> 
>  Acked-by: NeilBrown <neilb@suse.de>
> 
> thanks.
> 
> Not sure why there are two separate patches to md/bitmap.c though...
> 
> ... and I cannot offically 'ack' the dm-crypt.c parts of this as I'm not the
>     maintainer.  'md' and 'dm' are separate systems in the same directory -
>     confusing, isn't it :-(

These little walled gardens ... :)

I hope I can ack that dm-crypt code, I added that chunk
as part of loop-aes compatibility code.
(Anyway Alasdair as dm maintainer should ack it too.)

Acked-by: Milan Broz <mbroz@redhat.com>


>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 8c2a000..db6b516 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -590,9 +590,9 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
>>  	int r = 0;
>>  
>>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
>> -		src = kmap_atomic(sg_page(&dmreq->sg_in), KM_USER0);
>> +		src = kmap_atomic(sg_page(&dmreq->sg_in));
>>  		r = crypt_iv_lmk_one(cc, iv, dmreq, src + dmreq->sg_in.offset);
>> -		kunmap_atomic(src, KM_USER0);
>> +		kunmap_atomic(src);
>>  	} else
>>  		memset(iv, 0, cc->iv_size);
>>  
>> @@ -608,14 +608,14 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
>>  	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
>>  		return 0;
>>  
>> -	dst = kmap_atomic(sg_page(&dmreq->sg_out), KM_USER0);
>> +	dst = kmap_atomic(sg_page(&dmreq->sg_out));
>>  	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + dmreq->sg_out.offset);
>>  
>>  	/* Tweak the first block of plaintext sector */
>>  	if (!r)
>>  		crypto_xor(dst + dmreq->sg_out.offset, iv, cc->iv_size);
>>  
>> -	kunmap_atomic(dst, KM_USER0);
>> +	kunmap_atomic(dst);
>>  	return r;
>>  }
>>  
