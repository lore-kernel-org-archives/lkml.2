Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0DFIvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:51:47 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:34427 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab0DFIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:51:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGqRuktbstaW/2dsb2JhbACbTHK4JQ2EegSDQA
Date: Tue, 6 Apr 2010 10:51:38 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: James Hogan <james@albanarts.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, Trevor Keith <tsrk@tsrk.net>,
       James Hogan <james.hogan@imgtec.com>,
       Ladinu Chandrasinghe <ladinu.pub@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] watchdog docs: Fix use of WDIOC_SETOPTIONS ioctl.
Message-ID: <20100406085138.GG3823@infomag.iguana.be>
References: <u2j6a4b170b1004050331mf0ec0dd4pf2e47d9dda5e6be9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2j6a4b170b1004050331mf0ec0dd4pf2e47d9dda5e6be9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Will be added to the watchdog fixes that I'm preparing.

Thanks,
Wim.

> In the watchdog-test program and watchdog-api.txt, pass the values to
> the WDIOC_SETOPTIONS ioctl as a pointer to an integer containing the
> values intead of directly in the third ioctl argument. The actual
> watchdog drivers in drivers/watchdog don't read the options directly
> from the argument but use get_user and copy_from_user.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  Documentation/watchdog/src/watchdog-test.c |    8 ++++++--
>  Documentation/watchdog/watchdog-api.txt    |    5 ++---
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/watchdog/src/watchdog-test.c
> b/Documentation/watchdog/src/watchdog-test.c
> index a750532..63fdc34 100644
> --- a/Documentation/watchdog/src/watchdog-test.c
> +++ b/Documentation/watchdog/src/watchdog-test.c
> @@ -31,6 +31,8 @@ static void keep_alive(void)
>   */
>  int main(int argc, char *argv[])
>  {
> +    int flags;
> +
>      fd = open("/dev/watchdog", O_WRONLY);
> 
>      if (fd == -1) {
> @@ -41,12 +43,14 @@ int main(int argc, char *argv[])
> 
>      if (argc > 1) {
>  	if (!strncasecmp(argv[1], "-d", 2)) {
> -	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_DISABLECARD);
> +	    flags = WDIOS_DISABLECARD;
> +	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
>  	    fprintf(stderr, "Watchdog card disabled.\n");
>  	    fflush(stderr);
>  	    exit(0);
>  	} else if (!strncasecmp(argv[1], "-e", 2)) {
> -	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_ENABLECARD);
> +	    flags = WDIOS_ENABLECARD;
> +	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
>  	    fprintf(stderr, "Watchdog card enabled.\n");
>  	    fflush(stderr);
>  	    exit(0);
> diff --git a/Documentation/watchdog/watchdog-api.txt
> b/Documentation/watchdog/watchdog-api.txt
> index 4cc4ba9..eb7132e 100644
> --- a/Documentation/watchdog/watchdog-api.txt
> +++ b/Documentation/watchdog/watchdog-api.txt
> @@ -222,11 +222,10 @@ returned value is the temperature in degrees fahrenheit.
>      ioctl(fd, WDIOC_GETTEMP, &temperature);
> 
>  Finally the SETOPTIONS ioctl can be used to control some aspects of
> -the cards operation; right now the pcwd driver is the only one
> -supporting this ioctl.
> +the cards operation.
> 
>      int options = 0;
> -    ioctl(fd, WDIOC_SETOPTIONS, options);
> +    ioctl(fd, WDIOC_SETOPTIONS, &options);
> 
>  The following options are available:
> 
> -- 
> 1.6.6.1
