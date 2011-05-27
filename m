Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1E0IpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:45:13 -0400
Received: from smarthost.idnet.net ([212.69.40.140]:54684 "EHLO
	smarthost.idnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758787Ab1E0IpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:45:10 -0400
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 04:45:10 EDT
Subject: Re: [ORLinux] [PATCH 1/1] Apply transparent_union attribute to
 union semun
From: Jeremy Bennett <jeremy.bennett@embecosm.com>
Reply-To: jeremy.bennett@embecosm.com
To: jonas@southpole.se
Cc: linux-kernel@vger.kernel.org, joern.rennecke@embecosm.com,
        linux@openrisc.net
In-Reply-To: <1306448865-3142-1-git-send-email-jonas@southpole.se>
References: <1306448865-3142-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Embecosm
Date: Fri, 27 May 2011 09:13:06 +0100
Message-ID: <1306483986.9223.7.camel@thomas>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-AuthenticatedSender: jeremy.bennett.embecosm.com@idnet.net.uk
X-Originating-IP: [91.135.5.64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 00:27 +0200, jonas@southpole.se wrote: 
> From: Jonas Bonn <jonas@southpole.se>
> 
> The syscall handler for semctl is written under the assumption that the
> toolchain will pass "small" unions as function parameters directly instead
> of by reference.  The union semun is "small" and thus fits this description.
> 
> Since it is assumed that the union will be passed directly and not by
> reference, it is safe to access the union members without going via
> get_user.
> 
> The OpenRISC architecture, however, passes all unions by reference, thus
> breaking the above assumption.

Hi Jonas

Joern and I were discussing this - there is a case for changing the ABI.
It would certainly fix a debugging issue.

> The technically correct fix here is to mark the union as being transparent
> so that the ABI of the union's first element determines the parameter
> passing method and thus make explicit what's already implied in the function
> definition.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  include/linux/sem.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sem.h b/include/linux/sem.h
> index f2961af..6985c7d 100644
> --- a/include/linux/sem.h
> +++ b/include/linux/sem.h
> @@ -48,7 +48,7 @@ union semun {
>  	unsigned short __user *array;	/* array for GETALL & SETALL */
>  	struct seminfo __user *__buf;	/* buffer for IPC_INFO */
>  	void __user *__pad;
> -};
> +} __attribute__ ((transparent_union));
>  
>  struct  seminfo {
>  	int semmap;

Excellent. Semaphore test now passes. I look forward to rerunning
regression - we may be down to a single failure now!

Best wishes,


Jeremy

-- 
Tel:      +44 (1590) 610184
Cell:     +44 (7970) 676050
SkypeID: jeremybennett
Email:   jeremy.bennett@embecosm.com
Web:     www.embecosm.com

