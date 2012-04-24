Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2DXMvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:51:40 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:63140 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2DXMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:51:39 -0400
Message-ID: <20374.41396.280974.710188@ipc1.ka-ro>
Date: Tue, 24 Apr 2012 14:51:00 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Viresh Kumar <viresh.kumar@st.com>, mturquette@linaro.org,
        sshtylyov@mvista.com, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        viresh.linux@gmail.com, linux@arm.linux.org.uk,
        akpm@linux-foundation.org, jgarzik@redhat.com,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
In-Reply-To: <20120424120019.GE24089@lunn.ch>
References: <cover.1335266056.git.viresh.kumar@st.com>
	<abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
	<20120424120019.GE24089@lunn.ch>
X-Mailer: VM 8.1.0 under 23.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Lunn writes:
> > -#if defined(CONFIG_HAVE_CLK)
> >  	hpriv->clk = clk_get(&pdev->dev, NULL);
> > -	if (IS_ERR(hpriv->clk))
> > -		dev_notice(&pdev->dev, "cannot get clkdev\n");
> > -	else
> > -		clk_enable(hpriv->clk);
> > -#endif
> > +	if (IS_ERR(hpriv->clk)) {
> > +		dev_err(&pdev->dev, "cannot get clkdev\n");
> > +		return PTR_ERR(hpriv->clk);
> > +	}
> > +
> > +	clk_enable(hpriv->clk);
> 
> Sorry, but still wrong.
> 
> The clock is optional. If we can find a clock, turn it on. If not,
> keep going....
> 
> You patch causes the missing clock to become a fatal error.
> 
The clock API should accept NULL pointers as valid clocks and
treat them as NOP.
Thus drivers wouldn't have to worry about whether they actually got a
clock to manage or if their clocks are just dummies.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
