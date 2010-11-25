Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0KYBpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:45:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49729 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0KYBpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E281bsYAb1v+nmuLiXDHjKfGD9azVoiwNEZjrCuSr0q0m44Va0TImJAumPreMspCL+
         jnLwWKknaDEnEgTlo1p8nACjpA8rBlVNN3+Evb2CpiSseVnljkxs3hThFR5e8AifRZiy
         SwIr2aqt5qD7TC14ah5Sm8aPuYKTZbm7NS6ac=
MIME-Version: 1.0
In-Reply-To: <31169.1290641617@death>
References: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com>
	<31169.1290641617@death>
Date: Wed, 24 Nov 2010 17:45:42 -0800
Message-ID: <AANLkTi=-DzUmopboX13V_cd=mZnmD=mBNNCuhQYF0PQQ@mail.gmail.com>
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the
 slaves mac address
From: David Strand <dpstrand@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a use case where we assign a mac to the bond device, because
the slave device configuration may change periodically. With older
kernels, it honored the assigned mac and everything was fine, with
2.6.36 it now uses the mac of whatever slave device is first instead
of our assigned one.

ifenslave code and documentation appears to still support the old way,
where a bond assigned mac will reign supreme, so this patch restores
that behavior.

On Wed, Nov 24, 2010 at 3:33 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
>        How exactly is this a regression?  The above referenced patch
> changes the method used to decide if the bonding master needs to have
> it's MAC address set.  The original way was "bonding master's MAC is
> zero," after the above, it's "adding first slave."
>
>        Do you have some use case that manually sets the master's MAC
> address prior to adding any slaves?
>
>        -J
