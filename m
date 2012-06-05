Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883Ab2FELQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:16:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33702 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2FELQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:16:04 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Giancarlo ASNAGHI <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Alessandro Rubini <rubini@gnudd.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Date: Tue, 05 Jun 2012 13:19:26 +0200
Message-ID: <3650428.HarNR9HfNF@harkonnen>
User-Agent: KMail/4.8.3 (Linux/3.3.7-1.fc17.x86_64; KDE/4.8.3; x86_64; ; )
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
References: <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen> <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In some of these SoC's the C_CAN registers which are essentially
> 16-bit or 32-bit registers are aligned always to a 32-bit boundary
> (i.e. even a 16-bit register is aligned to 32-bit boundary).
> 
> So, I had to implement two variants of the read/write reg routines. I
> am not sure your SoC implementation needs them. If it does, I will
> categorize it as flaky as well :)

My implementation is align to 32, but I'm trying to make a generic PCI 
wrapper (some other could be aligned to 16)
 
> See above. There was a reason for keeping these routines in
> c_can_platform.c Simply put, every platform having a Bosch C_CAN
> module can have it's own implementation of the bus (for example you
> use PCI) and register bank layout (16-bit or 32-bit aligned).

I don't understand the reason to keep these functions in 
c_can_platform.c . Two generic read/write functions could be written 
into c_can.c by using a shift value (0 if aligned to 16, 1 if aligned to 
32) as I showed in the previous mail:

> > static u16 c_can_read_reg(struct c_can_priv *priv, enum reg index)
> > {
> > 
> > 	return readw(priv->base + (priv->regs[index] << priv->offset));
> > 
> > }
> > static void c_can_write_reg(struct c_can_priv *priv, enum reg index,
> > 
> > 						u16 val)
> > 
> > {
> > 
> > 	writew(val, priv->base + (priv->regs[index] << priv->offset));
> > 
> > }

Every platform having a Bosch C_CAN/D_CAN can specify its shift value (0 
or 1) and it's done.

-- 
Federico Vaga
