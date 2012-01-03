Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2ACQh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:37:29 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:35538 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752138Ab2ACQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:37:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: AnAtYJ4VM1kwLMeRy5O5ljB1rRAn7DUPDDpx_xlGd4bTM0H
 ZWhuGSk1ff7knU7ZsnbDzH7ApAcfkU7yrE4JTZ.AZEoUiHgqtrMcT1.ILHiC
 mY0SXX6yIEpkv1DNGHj6_gQqWzttojcDBzcZHyQajN6mOvVctKf0gFJVD85K
 jNy21n7IRqvBNs2Yq0c8JF02p1509VjTkOUvmbJaQkjLyThW90E4vjpLCw5i
 _Hq9anAoucm0EnFaS5f6biA9FjjYmfOsyQz_9F.dr6_IDNYIzW40k4_W4IKi
 Jf1Q_wquN_Rq09FLlCNiRhfQ4ciqqglAki9nHzdDVC96c8hsOzGyjLwGjJvF
 bqNmopgf4BeaDb4x7W3ayoUydPoJANdyrAIPcp_CZ_0GAng--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 3 Jan 2012 10:37:24 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: irqsafe_cpu_...() 64-bit operations on 32-bit platform
In-Reply-To: <4F018015020000780006A015@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.00.1201031034240.2810@router.home>
References: <4EF4581C0200007800069BA2@nat28.tlf.novell.com> <alpine.DEB.2.00.1112230908550.1691@router.home> <4F018015020000780006A015@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jan 2012, Jan Beulich wrote:

> > However, if you are using a loop to sum up all counters from every
> > processor then you cannot use the this_cpu ops but would have to use
> > something like get_64().
>
> I understand that, but again statistics aren't my focus here.

Ok then we need to understand better what you are trying to accomplish.
You may be outside of the realm of percpu data and be just trying to read
and write 64 bit variables reliably on 32 bit?

> Correct, but it would appear to be a read even to the compiler (only
> the actual assembly implementation would have to know that it's
> really a write).

I have had code like that floating around 2 years ago but there did not
seem to be a use case so I never merged it.

Do you have some code in the tree where I could see how you would use such
an operation?
