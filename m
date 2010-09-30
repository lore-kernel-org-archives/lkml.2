Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0I3IeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:34:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753084Ab0I3IeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:34:09 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18ofsRti5YoWgHgX5htqa065QC42sAGRZH14cb1+g
	AdHmt6VuCgxnu6
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dma-mapping commit breaks UML
Date: Thu, 30 Sep 2010 10:34:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201009291155.30873.toralf.foerster@gmx.de> <201009291629.39077.toralf.foerster@gmx.de> <20100930144059N.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100930144059N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009301034.01157.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FUJITA Tomonori wrote at 07:45:19
> On Wed, 29 Sep 2010 16:29:38 +0200
> 
> Toralf **UNKNOWN CHARSET** <toralf.foerster@gmx.de> wrote:
> > but catched another compile error - how can I now automatically
> > git-bisect for that wrong commit w/o heavy scripting ? - Or simply
> > asking who to blame wrt this compile error ?
> 
> Fortunately, looks like we can easily figure out the root cause of
> this (commit d6d1b650ae6acce73d55dd0246de22180303ae73), the last
> commit to arch/um/drivers/hostaudio_kern.c
> 
> The following patch works?

YES :-)

> diff --git a/arch/um/drivers/hostaudio_kern.c
> b/arch/um/drivers/hostaudio_kern.c index 0c46e39..63c740a 100644
> --- a/arch/um/drivers/hostaudio_kern.c
> +++ b/arch/um/drivers/hostaudio_kern.c
> @@ -40,6 +40,11 @@ static char *mixer = HOSTAUDIO_DEV_MIXER;
>  "    This is used to specify the host mixer device to the hostaudio
> driver.\n"\ "    The default is \"" HOSTAUDIO_DEV_MIXER "\".\n\n"
> 
> +module_param(dsp, charp, 0644);
> +MODULE_PARM_DESC(dsp, DSP_HELP);
> +module_param(mixer, charp, 0644);
> +MODULE_PARM_DESC(mixer, MIXER_HELP);
> +
>  #ifndef MODULE
>  static int set_dsp(char *name, int *add)
>  {
> @@ -56,15 +61,6 @@ static int set_mixer(char *name, int *add)
>  }
> 
>  __uml_setup("mixer=", set_mixer, "mixer=<mixer device>\n" MIXER_HELP);
> -
> -#else /*MODULE*/
> -
> -module_param(dsp, charp, 0644);
> -MODULE_PARM_DESC(dsp, DSP_HELP);
> -
> -module_param(mixer, charp, 0644);
> -MODULE_PARM_DESC(mixer, MIXER_HELP);
> -
>  #endif
> 
>  /* /dev/dsp file operations */


-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

