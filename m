Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0D0QAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:00:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56197 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0D0QAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:00:13 -0400
Date: Tue, 27 Apr 2010 11:59:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Steve deRosier <steve@cozybit.com>
Subject: Re: linux-next: April 27 (wireless/libertas warnings)
Message-ID: <20100427155914.GC25860@tuxdriver.com>
References: <4BD70485.1070203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD70485.1070203@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 08:36:37AM -0700, Randy Dunlap wrote:
> drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
> include/linux/kernel.h:376:1: warning: this is the location of the previous definition
> drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefined
> include/linux/kernel.h:376:1: warning: this is the location of the previous definition

Yup, just had this exchange w/ Stephen...

The problem comes from including slab.h before deb_defs.h (as done
in linux-next).  The version in wireless-testing avoids the warning
by including the headers in the other order, but that is a bit ugly.

Does anyone know if it is OK to #undef pr_fmt before defining it
in deb_defs.h?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
