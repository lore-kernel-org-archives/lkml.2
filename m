Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab2C1QTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:19:12 -0400
Received: from bosmailout08.eigbox.net ([66.96.189.8]:52994 "EHLO
	bosmailout08.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab2C1QTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:19:10 -0400
X-Greylist: delayed 2538 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 12:19:10 EDT
X-Authority-Analysis: v=2.0 cv=BexvJMR2 c=1 sm=1
 a=3J+lo41VBOXHbWqPWkUHww==:17 a=bc2JKO6qiGsA:10 a=goTC-lfFygsA:10
 a=lYYk3hvB4LwA:10 a=8nJEP1OIZ-IA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=pGLkceISAAAA:8 a=f4KU8n9It5R1aBcL4LwA:9 a=wPNLvfGTeEIA:10 a=MSl-tDqOz04A:10
 a=Kpo39fPXdbgqDwiI3/AEUA==:117
X-EN-OrigOutIP: 10.20.18.10
X-EN-IMPSID: r3cq1i00B0D2CUy013cqeP
Message-ID: <4F732FE0.1070708@yahoo.es>
Date: Wed, 28 Mar 2012 23:36:00 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Wang YanQing <udknight@gmail.com>, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute NX-protected
 page
References: <20120327100136.GA3829@udknight> <20120327143243.015ecff6@pyramind.ukuu.org.uk>
In-Reply-To: <20120327143243.015ecff6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.58.124
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/2012 9:32 PM, Alan Cox wrote:
> On Tue, 27 Mar 2012 18:01:36 +0800
> Wang YanQing <udknight@gmail.com> wrote:
>
>> Ok! I try to check pcibios_enabled first, but get some opposition by Alan Cox,
>> but I want to make thing work and fix the oops, so I choice the simple way to
>> check the (__supported_pte_mask & _PAGE_NX) instead of to check this variable plus
>> pci kernel boot parameter, pci mmconfig works or not, and more, and more. It is not
>> the best method, but it works and maybe all will feel happy.
> Okay let me ask the obvious question - why is it not the best method ?
>
> Apart from adding a helper in the includes for the arch code of
>
> 	static inline is_nx_enabled(void)
> 	{
> 		return !!(__supported_pte_mask & _PAGE_NX);
> 	}
>
> is there anything else it lacks ?

maybe giving this inline function a return type ?

