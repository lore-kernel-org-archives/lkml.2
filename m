Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2JBMYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:24:33 -0400
Received: from mail.tpi.com ([70.99.223.143]:4588 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab2JBMYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:24:30 -0400
Message-ID: <506ADCEB.1040109@canonical.com>
Date: Tue, 02 Oct 2012 06:24:11 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tyler Hicks <tyhicks@canonical.com>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [ 026/180] eCryptfs: Improve statfs reporting
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225158.719221314@1wt.eu> <20121002054655.GA17360@boyd>
In-Reply-To: <20121002054655.GA17360@boyd>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 10/01/2012 11:46 PM, Tyler Hicks wrote:
> On 2012-10-02 00:52:23, Willy Tarreau wrote:
>> 2.6.32-longterm review patch.  If anyone has any objections,
>> please let me know.
> 
> Hi - Please drop this patch. It incorrectly calculates f_namelen
> and I haven't had a chance to fix it yet. When I get a fix ready,
> I'll forward the corrected patch to stable@v.k.o. Thanks!
> 
> Tyler
> 
>> 
>> ------------------
>> 
>> From: Tyler Hicks <tyhicks@canonical.com>
>> 
>> commit 4a26620df451ad46151ad21d711ed43e963c004e upstream.
>> 
>> BugLink: http://bugs.launchpad.net/bugs/885744
>> 
>> statfs() calls on eCryptfs files returned the wrong filesystem
>> type and, when using filename encryption, the wrong maximum
>> filename length.
>> 
>> If mount-wide filename encryption is enabled, the cipher block
>> size and the lower filesystem's max filename length will
>> determine the max eCryptfs filename length. Pre-tested, known
>> good lengths are used when the lower filesystem's namelen is 255
>> and a cipher with 8 or 16 byte block sizes is used. In other,
>> less common cases, we fall back to a safe rounded-down estimate
>> when determining the eCryptfs namelen.
>> 
>> https://launchpad.net/bugs/885744
>> 
>> Signed-off-by: Tyler Hicks <tyhicks@canonical.com> Reported-by:
>> Kees Cook <keescook@chromium.org> Reviewed-by: Kees Cook
>> <keescook@chromium.org> Reviewed-by: John Johansen
>> <john.johansen@canonical.com> Signed-off-by: Colin Ian King
>> <colin.king@canonical.com> Acked-by: Stefan Bader
>> <stefan.bader@canonical.com> Signed-off-by: Tim Gardner
>> <tim.gardner@canonical.com> Signed-off-by: Willy Tarreau
>> <w@1wt.eu> --- fs/ecryptfs/crypto.c          |   68
>> ++++++++++++++++++++++++++++++++++++---- 
>> fs/ecryptfs/ecryptfs_kernel.h |   11 ++++++ 
>> fs/ecryptfs/keystore.c        |    9 ++--- fs/ecryptfs/super.c
>> |   18 ++++++++++- 4 files changed, 92 insertions(+), 14
>> deletions(-)

Tyler - this is the same patch that we're carrying in every kernel
from Lucid to Quantal, right ? Colin has verified test cases for this,
so I'm curious what you think is wrong. Something unique to 2.6.32 ?

https://bugs.launchpad.net/ecryptfs/+bug/885744/comments/5
https://bugs.launchpad.net/ecryptfs/+bug/885744/comments/9

rtg
- -- 
Tim Gardner tim.gardner@canonical.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQatzmAAoJED12yEX6FEfKwpsP/jgSVRAb3X/Xu1Hob46T2TD3
XFClsr4xWlRzrHKsKxDHZxYUKy6TexEB9ZagjfFIlteqbyEqOB+Eq/p7cFrouIlm
nX4/ERslly1H1tvm9x7hc3fUN3M8C5dwWsARjiRHY3luEZapIyMETnrikhahpZM5
xferd8RIowgTkDUfnLwBVhwagJSvpaBgavJq1Kn5+6ArEPWtT1AeiybHoJ0fOTb8
uNuCTjSHOhZh5ssConAyxhPiCgl0NYBdzHNPmuc+jO0ZDfb9NFfnNUUB6lRdrVhe
QJBXX1N4N90R70nnQBHFNWJCdMJpjbE80PdE/T8IAsUqa8IFpHzfZZJYRgMVUbc9
2nkQ+ZLTSOIy2IZSCGZzWA/kf9bRGuUF/KcPizpKEB7s2QDlPp3Rrt/zs1DRbnt5
FBWmfgtb37Hpz94EGaMQzTIAj0iZXqZ68njww3c1ELllCMmj+z/0UKktLCOhz3dO
ntlp8EUAD1F+Z5cMYxEP20Gn3EVvENSDfJnpdzWgTYzqNqFixCTC+cOWLl3OmCoL
2XxYDG6b6N6Y0dYMxjQV/DrptEXzr4kl70mLTa6yED6a3uxSSDGwRpM16feBR785
a83u27nVe9DLwJIo4D/gxmTiCsYZ7N5Y62hFMSwYgBFYrKDEq2wK6XizCerr11RB
NZ3Rh1IDrSVxBPwqpS/w
=z24H
-----END PGP SIGNATURE-----
