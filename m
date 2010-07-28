Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab0G1Hdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:33:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39058 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab0G1Hdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=osn3zmWneLGol3ZerboMkFbI0xCMclgjb9GLsbEdMHiBW9NHTGE8pTalS7co93x2rm
         HW7HShx1FM+KoDppl145zanWhYEJ8982kTczn9nUZb9bD3BdvNf2XSmxMxyZCmL1OYqj
         kIGyzZUmrEjxinB6sv3KK58lJe8BFjpiVrv/Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTiniwW+r1G40QvA+oja=1YDkykNWRahHL4LuiCAU@mail.gmail.com>
References: <AANLkTiniwW+r1G40QvA+oja=1YDkykNWRahHL4LuiCAU@mail.gmail.com>
Date: Wed, 28 Jul 2010 15:33:30 +0800
Message-ID: <AANLkTi=x0D_5yd7pWmYAcD2eeQN3HC9ecBXWEY-TpyYO@mail.gmail.com>
Subject: Re: BUG: 'Unknown symbol in module' happens after reloading ehci-hcd 
	module
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/28 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> 'Unknown symbol in module'  happens after the actions below:
>
>         rmmod ehci-hcd
>         modprobe ehci-hcd
>

The issue is caused by returning failure of debugfs_create_dir, and
which may be fixed by replacing debugfs_remove with
debugfs_remove_recursive in ehci_hcd_cleanup.

Why does insmod show 'Unknown symbol in module'  when module .init
return -ENOENT?  The message does make us confused.

-- 
Lei Ming
