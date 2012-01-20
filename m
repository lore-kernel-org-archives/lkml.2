Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2ATOuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:50:06 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:27155 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752830Ab2ATOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:50:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EyrD9KQVM1n9JiXR2DQWB.8hoElSkIEKmHKtXaM.M9VuciE
 3A2ho_PsSaEtRVwc.98o2CHijO3F_gWQKBgBiBtJrSZ4hUQ4PLLAVCDwzAGp
 tD8FhuVExAOFVdy72tIIcFHGat6mNxflGsRYrnSzBi9u1ThIRM2TWP2r7aZi
 MTsamYI9dndA1QqNLh_7ODZ0fiMECYiY0t6a3wKaYvwRXvi3htYRH9CB4q53
 DopSJffOiquH3fHL1cFqQGn9QBF76snnzWcSWXPe50V74kb0Nxm64bRWkf7e
 QFaPo8sOBShrQwlEkmUCIyrttMhTxBX0SO24YtyFn8PVgpRL29hON73dpnw0
 CirVIJhS5OTlELLary_BBgdZsYOEHzYPoSCzz4l0egpoKnxxsUr2zpPNzcs9
 FY.nQHMW8awemdHlcdD2Uzy3gGPglqodCl4fn
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 20 Jan 2012 08:49:57 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
In-Reply-To: <m1y5t3yuil.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.2.00.1201200848040.25882@router.home>
References: <1326558605.19951.7.camel@lappy> <1326561043.5287.24.camel@edumazet-laptop> <1326632384.11711.3.camel@lappy> <1326648305.5287.78.camel@edumazet-laptop> <alpine.DEB.2.00.1201170910130.4800@router.home> <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.DEB.2.00.1201170927020.4800@router.home> <1326814208.2259.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1201170942240.4800@router.home> <alpine.DEB.2.00.1201171620590.14697@router.home> <m1bopz2ws3.fsf@fess.ebiederm.org>
 <m14nvr2vbu.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1201191959540.14480@router.home> <m1y5t3yuil.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012, Eric W. Biederman wrote:

> On the flip side removing from sysfs with locks held must be done
> carefully, and as a default I would recommend not to hold locks over
> removing things from sysfs.  As removal blocks waiting for all of the
> callers into sysfs those sysfs attributes to complete.
>
> It looks like you are ok on the removal because none of the sysfs
> attributes appear to take the slub_lock, just /proc/slabinfo.  But
> it does look like playing with fire.

Ok then I guess my last patch is needed to make sysfs operations safe.

It may be good to audit the kernel for locks being held while calling
sysfs functions. Isnt there a lockdep check that ensures that no locks are
held?


