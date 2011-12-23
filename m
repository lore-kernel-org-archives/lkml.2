Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1LWLPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:15:16 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3650 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1LWLPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:15:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 23 Dec 2011 03:15:11 -0800
From: Alok Chauhan <alokc@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        Stephen Warren <swarren@nvidia.com>,
        "bones@secretlab.ca" <bones@secretlab.ca>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dgreid@google.com" <dgreid@google.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Fri, 23 Dec 2011 16:45:05 +0530
Subject: RE: [PATCH] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH] i2c: tegra: Add delay before reset the controller
Thread-Index: AczA9ZxzAn/Jn73iT+SgJWUzkwqrWAAbiW6g
Message-ID: <7A0BFCFE3DA5CD47B0FB7984326F201A134F2CCC73@BGMAIL01.nvidia.com>
References: <1324550480-26308-1-git-send-email-alokc@nvidia.com>
 <CAOesGMire-13yiA9gVQYFWdTa6ZLJLbTW8qoRoPMRQ1ExavVUQ@mail.gmail.com>
In-Reply-To: <CAOesGMire-13yiA9gVQYFWdTa6ZLJLbTW8qoRoPMRQ1ExavVUQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding Laxman Dewangan)

>This change causes problems systems with some models of i2c TPMs, since the first transaction to them will always time out (TPM quirk), and the delay means that the tpm will have time to go back to sleep and thus timeout >even on the retry. So you'll never make progress.
Working on this.

-Alok


-----Original Message-----
From: Olof Johansson [mailto:olof@lixom.net] 
Sent: Friday, December 23, 2011 2:48 AM
To: Alok Chauhan
Cc: khali@linux-fr.org; ben-linux@fluff.org; Stephen Warren; bones@secretlab.ca; paul.gortmaker@windriver.com; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org; dgreid@google.com
Subject: Re: [PATCH] i2c: tegra: Add delay before reset the controller

Hi,

(Adding linux-tegra and Dylan Reid who was debugging this before)

On Thu, Dec 22, 2011 at 2:41 AM, Alok Chauhan <alokc@nvidia.com> wrote:
> From: Alok Chauhan <alokc@nvidia.com>
>
> In NACK error condition, I2C controller violates clock-to-data setup 
> time before stop. In Software, because of this reset of controller is 
> happening before I2C controller could complete STOP condition.
>
> Added worst case delay of 1 ms (assuming lowest clock frequency will 
> be 1 KHZ) before reset the controller in case of NACK error.

This change causes problems systems with some models of i2c TPMs, since the first transaction to them will always time out (TPM quirk), and the delay means that the tpm will have time to go back to sleep and thus timeout even on the retry. So you'll never make progress.

In other words: this patch will break some systems and thus shouldn't be applied.


-Olof
