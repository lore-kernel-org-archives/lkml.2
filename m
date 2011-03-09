Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1CITqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:46:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1CITq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:46:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X0NL1zktcGrtnxWRnsl2CIK0ChB/ocEckY7fQPS0dRJxm0Hkqm6unncKLveLjaafzU
         whEV/zn3ALUK4HFZ2UwEr82QtnjlYjqsZDyCr0o/Lrqk3VHqf5rPH9L1JfIsI8K+39fZ
         ATCHEWaDHwL4rKZYMX17fN2Bjw8LEhlPcPedE=
Date: Wed, 9 Mar 2011 22:45:01 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
Message-ID: <20110309194501.GA9362@albatros>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Wed, Mar 09, 2011 at 14:33 -0500, Eric Paris wrote:
> someone complained that any user with
> cap_net_admin was able to load arbitrary kernel modules, even though the user
> didn't have cap_sys_module.  The reason is because the actual load is done by
> a usermode helper and those always have the full cap set.

AFAIU, your patch sets system-wide caps for _all_ usermode helpers,
right?  Then it does nothing with cap_net_admin's problem as it should
restrict caps of specific helpers spawned from specific networking code,
but not touching anything related to another helpers.

> sysctls which allow us to bound the permissions of usermode helpers.
> 
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable
> 
> You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
> When the kernel launches a usermodehelper it will do so with these as
> the bset and pI.

Thanks,

-- 
Vasiliy
