Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0LOWTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:19:07 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49825 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0LOWTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:19:04 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=EPI+Anp5axUU12/DJ58YCKzU/28JrKwJBM9MxN4j1qY= c=1 sm=1
 a=btxqJe0AtA4A:10 a=BLceEmwcHowA:10 a=8nJEP1OIZ-IA:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=KrBKqOs2yzgyODz0O-sA:9
 a=vqfLb2N71XgXUMI5np8A:7 a=wPkr9w9T9Ky2MIcZ5UYwANuYxS4A:4 a=wPNLvfGTeEIA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <1292446368.2603.13.camel@edumazet-laptop>
Date: Wed, 15 Dec 2010 15:19:00 -0700
Cc: Julia Lawall <julia@diku.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        P??draig Brady <P@draigBrady.com>,
        Am??rico Wang <xiyou.wangcong@gmail.com>, wharms@bfs.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7F573072-2CA4-4EE9-84AA-4AC6C7013CCA@dilger.ca>
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca> <4CECECA2.6070301@draigBrady.com> <20101124110535.GD5139@cr0.nay.redhat.com> <4CECFB19.1090003@draigBrady.com> <20101215094953.GG19804@ZenIV.linux.org.uk> <0BAF9CFC-72BF-49A1-93D3-BF60B892389B@dilger.ca> <Pine.LNX.4.64.1012152133010.29684@ask.diku.dk> <1292446368.2603.13.camel@edumazet-laptop>
To: Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-15, at 13:52, Eric Dumazet wrote:
> Le mercredi 15 décembre 2010 à 21:33 +0100, Julia Lawall a écrit :
>> On Wed, 15 Dec 2010, Andreas Dilger wrote:
>>> I thought my proposed solution was reasonable - add explicit padding fields where there are holes in the structure, which would be unused by the kernel, but since they are defined fields the compiler is obligated to initialize them.
>> 
>> Is the presence of holes always apparent at the source code level?
>> Or is it dependent on the compiler or target architecture?
> 
> It depends on target architecture.
> 
> This means doing a full review to add a named padding only for arches
> that need it.

There are automated tools like "pahole" (IIRC) that will report the presence of these structure holes.  However, the memset(0) won't add itself to the code either (i.e. it needs an audit to determine if it is needed).

Cheers, Andreas





