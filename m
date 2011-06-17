Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1FQRbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:31:22 -0400
Received: from mail.southpole.se ([193.12.106.18]:48787 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1FQRbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:31:21 -0400
Subject: Re: [PATCH 1/1] Apply transparent_union attribute to union semun
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: linux@openrisc.net
In-Reply-To: <1306448865-3142-1-git-send-email-jonas@southpole.se>
References: <1306448865-3142-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Fri, 17 Jun 2011 19:31:17 +0200
Message-ID: <1308331877.2653.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I never got any feedback on this patch... is this an acceptable solution
for upstream?  ...or is the usage of this GCC extension discouraged?
/Jonas

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
> 
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


