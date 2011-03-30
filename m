Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab1C3LjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:39:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab1C3LjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:39:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Date: Wed, 30 Mar 2011 13:38:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        m-watkins@ti.com, "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <201103111628.57549.arnd@arndb.de> <9E9CA0E03AAF4C9AA18DDD7CDE5168A8@subhasishg>
In-Reply-To: <9E9CA0E03AAF4C9AA18DDD7CDE5168A8@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301338.57207.arnd@arndb.de>
X-Provags-ID: V02:K0:kX/sTjBL9bGga66mxYZfkyYAyl/KMDNgy8121Y3Y58P
 RLNBvFim8xrt7PfciaOB1pGUuUena590gOcsFhga9srAkOakQ0
 Z2jqF99FqzvOSrJi3vhMU590WRewBOi1/UNrEea8uci52dquIb
 s0d1uAfZ2nb5samUbLW16eW66OFBJsIatn9nEM9wAcS8z8DByU
 lfmKc4IhRuhLDOZewQBNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011, Subhasish Ghosh wrote:
> I am using a .setup to initialize pin mux etc. To use the mfd_cells directly 
> should I
> use .enable and .disable of the mfd_cells instead of the .setup.

I think it would be best not to define any per-board functions that
are needed to set up the cell, but rather to initialize it from
the ->probe function of the cell specific driver.

If you need board specific data such as GPIO lists, you can pass
them in the mfd_cell platform_data.
	
	Arnd
