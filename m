Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0HaSgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:36:17 -0400
Received: from kroah.org ([198.145.64.141]:50924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0HaSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:36:16 -0400
Date: Tue, 31 Aug 2010 11:33:43 -0700
From: Greg KH <greg@kroah.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6656: Remove the ULONG_PTR and DWORD_PTR
 defines from ttype.h
Message-ID: <20100831183343.GA5350@kroah.com>
References: <1278974997-27141-1-git-send-email-roel.vannyen@gmail.com>
 <4c5ae57d.d37b0e0a.1ef9.19ba@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c5ae57d.d37b0e0a.1ef9.19ba@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 06:23:21PM +0200, Roel Van Nyen wrote:
> I have re-done my patch and this time without any checkpatch.pl errors.

Well, some you can ignore:

> 
> Remove DWORD_PTR and ULONG_PTR from ttype.h
> 
> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> ---
>  drivers/staging/vt6656/bssdb.c |    8 ++++----
>  drivers/staging/vt6656/ttype.h |    4 ----
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
> index a9f68bd..024dff3 100644
> --- a/drivers/staging/vt6656/bssdb.c
> +++ b/drivers/staging/vt6656/bssdb.c
> @@ -466,7 +466,7 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>  	unsigned int uLen = pRSNWPA->len + 2;
>  
>  	if (uLen <= (uIELength -
> -		     (unsigned int) (ULONG_PTR) ((PBYTE) pRSNWPA - pbyIEs))) {
> +	(unsigned int) (unsigned long) ((PBYTE) pRSNWPA - pbyIEs))) {

That's just horrible, move it to the right like it was, just don't add
the extra spaces where they are not needed.  And think, why would you
want to cast from an unsigned long and then to an unsigned int,
something is really wrong with that code, it should be fixed properly.

Care to try again?

thanks,

greg k-h
