Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1CXSB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:01:56 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:30948 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756177Ab1CXSBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:01:55 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: TxrMeLgVM1nRHyfDssGrGsny0Dc7S90BwYG1kfkgaP.zSUj
 CXL0hcq6lrcBNLHkIi9q6l_vHHTiU6HvbjHS2WTALAaJ1pPba3d.f4QUiG0L
 Sn2C3dwe2EAY_Og2wW4kXhsaZ5Zec9DuKvfCbhmeyPgzTa4k_52IctfordH5
 iKUZLqo9O43.hp._h_TJolUj6joKzLW5BQFoZeMxGcN57RendzSnAmdzBjth
 h5JxwO4_YTPTHeQJKxYiaNGcyaCyU.cJfayZ9nrRhEXFk0FgYJTVoo0tCETf
 qMIdHpcmpkOuR9AXc0pm5DXbJbgtfrYP2ISuZUdI.GTcxq5ye
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 13:01:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103241300420.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu> <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu>
 <alpine.DEB.2.00.1103241242450.32226@router.home> <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Pekka Enberg wrote:

> On Thu, Mar 24, 2011 at 7:43 PM, Christoph Lameter <cl@linux.com> wrote:
> > The bug should only trigger on old AMD64 boxes that do not support
> > cmpxchg16b.
>
> Yup. Ingo is it possible to see /proc/cpuinfo of one of the affected
> boxes? I'll try your config but I'm pretty sure the problem doesn't
> trigger here. Like I said, I think the problem is that alternative
> instructions are not patched early enough for cmpxchg16b emulation to
> work for kmem_cache_init(). I tried my check_bugs() patch but it hangs
> during boot. I'll see if I can cook up a patch that does
> alternative_instructions() before kmem_cache_init() because I think
> those *should* be available during boot too.

I forced the fallback to the _emu function to occur but could not trigger
the bug in kvm.

