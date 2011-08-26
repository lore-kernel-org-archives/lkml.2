Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1HZPFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:05:21 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:38272 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752694Ab1HZPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:05:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yDffVuYVM1lDayTNR3TB1SfbYCEFgm7SnhnZT6wX_RK1Peh
 fiewIQut_VQxot7wtJYswp1b06xzXN81lot7R4GlSwnuDYUS4n__i6zmLSS7
 g4IyT3mO7.VhtZ40.NCczo7U0kn1R1f0tzipdfarlz3ZjBQLgJvQGv3eNwT7
 81EK9SODyNAyfUMItxDNggDMRhxTMMTklQ_YW.v0gRAmsdHmkiBQfTSPMF7x
 fuUdWwzgbAzZjAne.drtbkLXyeewCoeAZeY65tAMvyLmyVIg6F8OwjOeHJQF
 BiimaER7zbsSUUb771.SXXINFaY4u_buZPR4Wsx4ojs7eNJyHkDlnPR0HpmI
 MkAU_bV.c1p2lLY1XPp53P62Di0fxAm22.nYH_JzarVgrRQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 26 Aug 2011 10:05:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Zhao Jin <cronozhj@gmail.com>
cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
In-Reply-To: <1314370954.8991.46.camel@vm>
Message-ID: <alpine.DEB.2.00.1108261004430.5818@router.home>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>  <alpine.DEB.2.00.1108260841570.5818@router.home>  <1314370016.8991.38.camel@vm>  <alpine.DEB.2.00.1108260950220.5818@router.home> <1314370954.8991.46.camel@vm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Zhao Jin wrote:

> > Correct but still tthe del/add is a list_move operation. Convert that the
> > other case as well?
> >
> Yes. The patch avoids list_del/list_add only if it is the case that a
> partial slab was used for refilling and remains partial (that is:
> partial => partial). If it is not the case( so it must be either partial
> => full, free => full or free => partial) the patched code behaves the
> same as current (list_del/list_add).

The second case is what I want you to change to list_move.


