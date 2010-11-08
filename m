Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0KHIax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:30:53 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:59532 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab0KHIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:30:52 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 6D593AA53F
Message-Id: <E1PFN7q-0000z3-Em@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH RFC] Restrictions on module loading
To: Dan Rosenberg <drosenberg@vsecurity.com>, security@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Mon, 08 Nov 2010 09:30:50 +0100
References: <fMoIy-7gR-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> The below patch replaces the existing "modules_disable" sysctl with a
> finer-grained "modules_restrict" sysctl.  By default, this is set at 0,
> which results in no deviation from normal module loading behavior.  When
> set to 1, unprivileged users cannot trigger the automatic loading of
> modules.  This behavior is based on grsecurity's GRKERNSEC_MODHARDEN
> setting.  The current check is against current_uid(), since several
> distributions explicitly remove CAP_SYS_MODULE from root processes, some
> of which incidentally cause (and rely on) the automatic loading of
> modules.  I expect this to be a point of discussion.

- Why don't you offer both?

- What about task switches or work queues?

- It might be more like the expected behavior if you'd used:
 0: off, 1: modules completely disabled, 2: CAP_SYS_MODULE, 3: uid==0

 Many users will forget to look into the documentation or find the current,
 stale documentation or just assume a boolean value.

