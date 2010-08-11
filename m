Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab0HKBje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:39:34 -0400
Received: from ozlabs.org ([203.10.76.45]:47199 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0HKBjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:39:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH 1/2] param: allow omitting set() methods for truly read-only params
Date: Wed, 11 Aug 2010 11:09:30 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <lenb@kernel.org>
References: <1281466725-22549-1-git-send-email-dtor@vmware.com>
In-Reply-To: <1281466725-22549-1-git-send-email-dtor@vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008111109.30433.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 04:28:44 am Dmitry Torokhov wrote:
> Certain "parameters", such as acpica version and upcoming VMware Balloon
> version, are need to be purely read-only. They are exported as
> parameters so that they are visible in sysfs even in cases when the
> module is built directly into the kernel, but their values should be
> immutable. Specifying S_IRUGO takes care of sysfs interface, but it
> has no effect on kernel command line or modprobe configuration files and
> so these "parameters" attempt to omit set() method. Unfortunately
> kernel expects set() to be always present and crashes if it is not
> there, so let's add appropriate check.
> 
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>

That almost makes sense, but not quite.

Your followup patch uses this for version, but the version is already
in /sys/module/vmware_balloon/version as is standard with modules, no?

Confused,
Rusty.
