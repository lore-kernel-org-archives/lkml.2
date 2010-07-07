Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0GGCuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:50:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:58223 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751769Ab0GGCuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:50:52 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18Vs7gpcQgVq8qIiP9d2OWOAjBSBSC8s76u18/fSN
	l553wU3bjMVRcy
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Re: Oops after unloading staging/panel/panel.ko
Date: Wed, 7 Jul 2010 04:50:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
References: <201007070313.38814.PeterHuewe@gmx.de> <201007070338.50023.PeterHuewe@gmx.de>
In-Reply-To: <201007070338.50023.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007070450.49479.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 07 Juli 2010 03:38:49 schrieb Peter Hüwe:
> Here is another oops trace caused by the same problem.

I think I've tracked it down.

parport_release and parport_unregister_device get called twice while unloading 
the module - after the first call the handle isn't valid anymore and thus 
causes the oops.

I'll send a patch soon.

Peter
