Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0LAFaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:30:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38697 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LAFae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O402hgt81Hg9wqwScuUOAG19Kj2J7pGcBndnruH6R1szlrE7higae1VojMsnPcfnVG
         Bf2yc9wCn/MLVoalZ0X9BMMViX2YaDz+5QkKIcxVP/PF2AFVJN+8yDSE0mPklHQbpoYS
         fo54lAleJSBd/ZGeGFFJYHowv7Nne/YUk4f9g=
MIME-Version: 1.0
In-Reply-To: <1291154254-22533-9-git-send-email-cdhmanning@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
	<1291154254-22533-9-git-send-email-cdhmanning@gmail.com>
Date: Wed, 1 Dec 2010 16:30:32 +1100
Message-ID: <AANLkTi=SXnSowvzm3Mu-1357HSzBTuBcrUBuwpN04sFH@mail.gmail.com>
Subject: Re: [PATCH 8/8] Add yaffs2 file system: VFS glue code, hook into
 kernel tree building
From: Nick Piggin <npiggin@gmail.com>
To: Charles Manning <cdhmanning@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 8:57 AM, Charles Manning <cdhmanning@gmail.com> wrote:

> +#define UnlockPage(p) unlock_page(p)
> +#define Page_Uptodate(page)    test_bit(PG_uptodate, &(page)->flags)

You should never be testing page flags by hand, outside mm code.

Why aren't you using PageUptodate()?
