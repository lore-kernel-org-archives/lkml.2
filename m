Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab2CYQHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 12:07:47 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44019 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756525Ab2CYQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 12:07:45 -0400
Message-ID: <4F6F42CB.1020905@xenotime.net>
Date: Sun, 25 Mar 2012 09:07:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, perex@perex.cz, tiwai@suse.de,
        davem@davemloft.net
Subject: Re: [PATCHES v2 1/2] Documentation: replace install commands with
 softdeps
References: <1331964803-25570-1-git-send-email-lucas.demarchi@profusion.mobi>
In-Reply-To: <1331964803-25570-1-git-send-email-lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 11:13 PM, Lucas De Marchi wrote:

> Install commands should not be used to specify soft dependencies among
> modules. When loading modules it's much better to have a softdep that
> modprobe knows what's being done than having to fork/exec another
> instance of modprobe to load the other module.
> 
> By using a softdep user has also an option to remove the dependencies
> when removing the module (and if its refcount dropped to 0)
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>


Applied, thanks.


> ---
> 
> v2: addressed comments from Takashi Iwai and split the patch in two. There were
> some changes to install commands that are better placed in a separate patch
> 
> 
>  Documentation/networking/bonding.txt    |    3 +--
>  Documentation/sound/oss/AudioExcelDSP16 |    4 ++--
>  Documentation/sound/oss/README.modules  |    2 +-
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
> index 080ad26..2d38eee 100644
> --- a/Documentation/networking/bonding.txt
> +++ b/Documentation/networking/bonding.txt
> @@ -1826,8 +1826,7 @@ an equivalent problem can occur.  In this case, the following can be
>  added to modprobe.conf (or modprobe.conf.local, as appropriate), as
>  follows (all on one line; it has been split here for clarity):
>  
> -install bonding /sbin/modprobe tg3; /sbin/modprobe e1000;
> -	/sbin/modprobe --ignore-install bonding
> +softdep bonding pre: tg3 e1000
>  
>  	This will, when loading the bonding module, rather than
>  performing the normal action, instead execute the provided command.
> diff --git a/Documentation/sound/oss/AudioExcelDSP16 b/Documentation/sound/oss/AudioExcelDSP16
> index e0dc064..30cfccc 100644
> --- a/Documentation/sound/oss/AudioExcelDSP16
> +++ b/Documentation/sound/oss/AudioExcelDSP16
> @@ -54,8 +54,8 @@ Loading MSS and OPL3 needs to pre load the aedsp16 module to set up correctly
>  the sound card. Installation dependencies must be written in the modprobe.conf
>  file:
>  
> -install ad1848 /sbin/modprobe aedsp16 && /sbin/modprobe -i ad1848
> -install opl3 /sbin/modprobe aedsp16 && /sbin/modprobe -i opl3
> +softdep ad1848 pre: aedsp16
> +softdep opl3 pre: aedsp16
>  
>  Then you must load the sound modules stack in this order:
>  sound -> aedsp16 -> [ ad1848, opl3 ]
> diff --git a/Documentation/sound/oss/README.modules b/Documentation/sound/oss/README.modules
> index e691d74..716615a 100644
> --- a/Documentation/sound/oss/README.modules
> +++ b/Documentation/sound/oss/README.modules
> @@ -36,7 +36,7 @@ options adlib_card io=0x388     # FM synthesizer
>   Alternatively, if you have compiled in kernel level ISAPnP support:
>  
>  alias char-major-14 sb
> -post-install sb /sbin/modprobe "-k" "adlib_card"
> +softdep sb post: adlib_card
>  options adlib_card io=0x388
>  
>    The effect of this is that the sound driver and all necessary bits and



-- 
~Randy
