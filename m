Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1HQKxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:53:09 -0400
Received: from mga10.intel.com ([192.55.52.92]:28341 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752821Ab1HQKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:53:06 -0400
Message-ID: <4E4B9DD8.3060303@intel.com>
Date: Wed, 17 Aug 2011 13:54:16 +0300
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Organization: Intel Finland Oy, Helsinki, Finland
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [RFC v1.1 2/5] crypto: ksign - digital signature verification
 support
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <8abcf5f23fc65590340f51399fc2d60cf4e62f30.1313082284.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1108161059260.7706@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1108161059260.7706@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/08/11 04:00, James Morris wrote:
> On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:
>
>> +static int ksign_verify_rsa(struct key *key,
>> +		    const char *sig, int siglen,
>> +		       const char *h, int hlen)
>> +{
>> +	int err = -ENOMEM;
>> +	unsigned long len;
>> +	unsigned long mlen, mblen;
>> +	unsigned nret, l;
>> +	int valid, head, i;
>> +	unsigned char *out1 = NULL, *out2 = NULL;
>> +	MPI in = NULL, res = NULL, pkey[2];
>> +	uint8_t *p, *datap, *endp;
>> +	struct user_key_payload *ukp;
>> +	struct pubkey_hdr *pkh;
>> +
>> +	down_read(&key->sem);
>> +	ukp = key->payload.data;
>> +	pkh = (struct pubkey_hdr *)ukp->data;
>> +
>> +	if (pkh->version != 1)
>> +		return -EINVAL;
>> +
>> +	if (pkh->algo != PUBKEY_ALGO_RSA)
>> +		return -EINVAL;
> Are you supposed to be still holding key->sem here?
>
Of course not.
that was late addition. Should be goto as in following cases...

- Dmitry

