Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2E2K2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:28:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53021 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2E2K2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
References: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
Date: Tue, 29 May 2012 18:28:45 +0800
Message-ID: <CAJxxZ0NK5HnvBUxBWdKq+saJfyWG1Uk0nDpRJ-uAmApgZBP7CQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: Add new test cases for Blackfin CRC crypto driver.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING

On Fri, May 25, 2012 at 5:54 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  crypto/tcrypt.c  |    3 ++
>  crypto/testmgr.c |    9 +++++
>  crypto/testmgr.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 102 insertions(+), 0 deletions(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 8f147bf..750cce4 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -1192,6 +1192,9 @@ static int do_test(int m)
>        case 109:
>                ret += tcrypt_test("vmac(aes)");
>                break;
> +       case 110:
> +               ret += tcrypt_test("hmac(crc32)");
> +               break;
>
>        case 150:
>                ret += tcrypt_test("ansi_cprng");
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 5674878..eb6d20f 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2220,6 +2220,15 @@ static const struct alg_test_desc alg_test_descs[] = {
>                        }
>                }
>        }, {
> +               .alg = "hmac(crc32)",
> +               .test = alg_test_hash,
> +               .suite = {
> +                       .hash = {
> +                               .vecs = bfin_crc_tv_template,
> +                               .count = BFIN_CRC_TEST_VECTORS
> +                       }
> +               }
> +       }, {
>                .alg = "hmac(md5)",
>                .test = alg_test_hash,
>                .suite = {
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 36e5a8e..34a9d51 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -14858,4 +14858,94 @@ static struct hash_testvec crc32c_tv_template[] = {
>        },
>  };
>
> +/*
> + * Blakcifn CRC test vectors
> + */
> +#define BFIN_CRC_TEST_VECTORS 6
> +
> +static struct hash_testvec bfin_crc_tv_template[] = {
> +       {
> +               .psize = 0,
> +               .digest = "\x00\x00\x00\x00",
> +       },
> +       {
> +               .key = "\x87\xa9\xcb\xed",
> +               .ksize = 4,
> +               .psize = 0,
> +               .digest = "\x87\xa9\xcb\xed",
> +       },
> +       {
> +               .key = "\xff\xff\xff\xff",
> +               .ksize = 4,
> +               .plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
> +                            "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
> +                            "\x11\x12\x13\x14\x15\x16\x17\x18"
> +                            "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
> +                            "\x21\x22\x23\x24\x25\x26\x27\x28",
> +               .psize = 40,
> +               .digest = "\x84\x0c\x8d\xa2",
> +       },
> +       {
> +               .key = "\xff\xff\xff\xff",
> +               .ksize = 4,
> +               .plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
> +                            "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
> +                            "\x11\x12\x13\x14\x15\x16\x17\x18"
> +                            "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
> +                            "\x21\x22\x23\x24\x25\x26",
> +               .psize = 38,
> +               .digest = "\x8c\x58\xec\xb7",
> +       },
> +       {
> +               .key = "\xff\xff\xff\xff",
> +               .ksize = 4,
> +               .plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
> +                            "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
> +                            "\x11\x12\x13\x14\x15\x16\x17\x18"
> +                            "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
> +                            "\x21\x22\x23\x24\x25\x26\x27",
> +               .psize = 39,
> +               .digest = "\xdc\x50\x28\x7b",
> +       },
> +       {
> +               .key = "\xff\xff\xff\xff",
> +               .ksize = 4,
> +               .plaintext = "\x01\x02\x03\x04\x05\x06\x07\x08"
> +                            "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
> +                            "\x11\x12\x13\x14\x15\x16\x17\x18"
> +                            "\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20"
> +                            "\x21\x22\x23\x24\x25\x26\x27\x28"
> +                            "\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30"
> +                            "\x31\x32\x33\x34\x35\x36\x37\x38"
> +                            "\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40"
> +                            "\x41\x42\x43\x44\x45\x46\x47\x48"
> +                            "\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50"
> +                            "\x51\x52\x53\x54\x55\x56\x57\x58"
> +                            "\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60"
> +                            "\x61\x62\x63\x64\x65\x66\x67\x68"
> +                            "\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70"
> +                            "\x71\x72\x73\x74\x75\x76\x77\x78"
> +                            "\x79\x7a\x7b\x7c\x7d\x7e\x7f\x80"
> +                            "\x81\x82\x83\x84\x85\x86\x87\x88"
> +                            "\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90"
> +                            "\x91\x92\x93\x94\x95\x96\x97\x98"
> +                            "\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0"
> +                            "\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8"
> +                            "\xa9\xaa\xab\xac\xad\xae\xaf\xb0"
> +                            "\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8"
> +                            "\xb9\xba\xbb\xbc\xbd\xbe\xbf\xc0"
> +                            "\xc1\xc2\xc3\xc4\xc5\xc6\xc7\xc8"
> +                            "\xc9\xca\xcb\xcc\xcd\xce\xcf\xd0"
> +                            "\xd1\xd2\xd3\xd4\xd5\xd6\xd7\xd8"
> +                            "\xd9\xda\xdb\xdc\xdd\xde\xdf\xe0"
> +                            "\xe1\xe2\xe3\xe4\xe5\xe6\xe7\xe8"
> +                            "\xe9\xea\xeb\xec\xed\xee\xef\xf0",
> +               .psize = 240,
> +               .digest = "\x10\x19\x4a\x5c",
> +               .np = 2,
> +               .tap = { 31, 209 }
> +       },
> +
> +};
> +
>  #endif /* _CRYPTO_TESTMGR_H */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
