Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2LKRkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:40:10 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60943 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2LKRkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:40:08 -0500
Date: Tue, 11 Dec 2012 17:45:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lior Amsalem <alior@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211174509.69c8c66e@pyramind.ukuu.org.uk>
In-Reply-To: <20121211173450.GW14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
	<20121211162647.GS14363@n2100.arm.linux.org.uk>
	<20121211171610.01c2de16@pyramind.ukuu.org.uk>
	<20121211173450.GW14363@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem comes when you end up trying to deal with stuff which
> uses ioread{8,16} on ioport_map() cookies where it's assumed that
> adding N to the cookie is the same as adding N to the port address.

It's a cookie - this isn't a problem, you can support it via the mapping
approah. Whether you want to is another question.

> Thankfully those platforms aren't going to be a part of the single
> zImage project...

Don't blame you 8)
