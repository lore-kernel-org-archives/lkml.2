Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2DPAQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 20:16:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57310 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2DPAQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 20:16:39 -0400
MIME-Version: 1.0
In-Reply-To: <1334206506.7150.386.camel@deadeye>
References: <20120411231036.581670888@linuxfoundation.org> <1334206506.7150.386.camel@deadeye>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 15 Apr 2012 20:16:08 -0400
X-Google-Sender-Auth: IAkQ26F7gJJmwxtdUfIWs42LHwY
Message-ID: <CAP=VYLp6F3YB_71aX=FxLf_dz7kzs-W+dPcA4OmC0VV0kQteiw@mail.gmail.com>
Subject: Re: [ 06/59] Fix non TBI PHY access; a bad merge undid bug fix in a
 previous commit.
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenth Eriksson <kenth.eriksson@transmode.com>,
        "David S. Miller" <davem@davemloft.net>, afleming@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:55 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>>
>> From: Kenth Eriksson <kenth.eriksson@transmode.com>
>>
>> [ Upstream commit 464b57da56910c8737ede75ad820b9a7afc46b3e ]
>>
>> The merge done in commit b26e478f undid bug fix in commit c3e072f8
>> ("net: fsl_pq_mdio: fix non tbi phy access"), with the result that non
>> TBI (e.g. MDIO) PHYs cannot be accessed.
> [...]
>
> This doesn't look relevant to 3.2.
>
> $ git describe --contains b26e478f
> v3.3-rc1~182^2~207
> $ git describe --contains c3e072f8
> v3.3-rc1~182^2~598
> $ git show c3e072f8 | head -8
> commit c3e072f8a6c5625028531c40ec65f7e301531be2
> Author: Baruch Siach <baruch@tkos.co.il>
> Date:   Mon Nov 14 08:21:30 2011 +0200
>
>    net: fsl_pq_mdio: fix non tbi phy access
>
>    Since 952c5ca1 (fsl_pq_mdio: Clean up tbi address configuration) .probe returns
>    -EBUSY when the "tbi-phy" node is missing. Fix this.
> $ git describe --contains 952c5ca1
> v3.3-rc1~182^2~603
> $ git rev-list v3.2..v3.2.14 drivers/net/ethernet/freescale/fsl_pq_mdio.c

I think 952c5ca1 is a red herring;  What is called out as the regression
commit appeared in tree earlier than that as 28d8ea2d568.

$ git describe --contains 28d8ea2d568
v3.2-rc6~3^2~6
$ git show 952c5ca1|diffstat -p0
 b/drivers/net/ethernet/freescale/fsl_pq_mdio.c |   53 +++----------------------
 1 file changed, 8 insertions(+), 45 deletions(-)
$ git show  28d8ea2d568 | diffstat -p0
 b/drivers/net/ethernet/freescale/fsl_pq_mdio.c |   53 +++----------------------
 1 file changed, 8 insertions(+), 45 deletions(-)
$

I documented some history about this in commit 1ee4af86fa16d636.

I wasn't aware of the bad merge at the time; adding the TBI node to
my mpc836x board DTS simply fixed the issue with no source changes.

Paul.

> $
>
> Ben.
>
> --
> Ben Hutchings
> It is easier to change the specification to fit the program than vice versa.
