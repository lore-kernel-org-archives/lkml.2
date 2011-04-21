Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1DUNLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:11:13 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:46485 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUNLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:11:11 -0400
Date: Thu, 21 Apr 2011 15:02:19 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ciprian Docan <docan@eden.rutgers.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael, J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
        nic_swsd@realtek.com
Subject: Re: Suspend/resume - slow resume
Message-ID: <20110421130219.GA19021@electric-eye.fr.zoreil.com>
References: <20110417101731.GA17986@electric-eye.fr.zoreil.com> <BANLkTi=tPc6NmUuTYqbVZduNRNbE=-c34Q@mail.gmail.com> <20110418180813.GA18469@electric-eye.fr.zoreil.com> <BANLkTim_1OgqjCeD1a4Ay2fWJSmPHa_XTQ@mail.gmail.com> <Pine.SOC.4.64.1104181519490.1320@er3.rutgers.edu> <BANLkTi=dke10HougmiQn9hSF15nK0B8mdA@mail.gmail.com> <20110420181602.GA18740@electric-eye.fr.zoreil.com> <Pine.SOC.4.64.1104201507140.1320@er3.rutgers.edu> <20110420195330.GB18897@electric-eye.fr.zoreil.com> <Pine.SOC.4.64.1104202204090.1320@er3.rutgers.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.1104202204090.1320@er3.rutgers.edu>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciprian Docan <docan@eden.rutgers.edu> :
[...]
> @@ -1789,25 +1800,26 @@ rtl_phy_write_fw(struct rtl8169_private *tp, const struct firmware *fw)
>  
>  static void rtl_release_firmware(struct rtl8169_private *tp)
>  {
> -	release_firmware(tp->fw);
> -	tp->fw = NULL;
> +	if (!IS_ERR_OR_NULL(tp->fw))
> +		release_firmware(tp->fw);

Ok.

Nit: the test against NULL is not needed here.

-- 
Ueimor

