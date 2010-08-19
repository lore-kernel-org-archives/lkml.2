Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab0HSEPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 00:15:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50842 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0HSEPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 00:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=c/OmfH9SkAHKTJaGhvHxVrvQ0ZblwXTyf8/mJ5C4FIR0Smpr6WwSET3KMtIdoa3GR+
         XFO30aGEhS9JebGFlACyGbQoKJk/TK1wDf0rOpGDvK3/fQPPodNEJPMhja4tGdsYJtua
         ov1PR8t68sYjAVgNK8pa/EGVWjf/5ucQgwLQg=
MIME-Version: 1.0
Date: Thu, 19 Aug 2010 12:15:48 +0800
Message-ID: <AANLkTinxVG=X-ncpF21kxh+XifUOtLHBfsP2FJ-Cgx6U@mail.gmail.com>
Subject: Is it possible for addrconf_init_net to kfree no-heap address?
From: ye janboe <janboe.ye@gmail.com>
To: davem@davemloft.net, xemul@openvz.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Pavel and David

addrconf_init_net make me a little confused.

if all and dflt are not allocated by kmemdup and sysctl_register
failed, this function will try to kfree dftl which points to
ipv6_devconf_dfl which is not a heap address. AFAIK, kfree will panic
if the address does not belong to slab page.

Is there any special reason for these codes?

many thanks!

-- 
Janboe Ye
