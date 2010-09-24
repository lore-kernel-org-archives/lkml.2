Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab0IXFCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:02:44 -0400
Received: from lo.gmane.org ([80.91.229.12]:45641 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab0IXFCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:02:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] x86/hwmon: don't leak device attribute file =?utf-8?b?ZnJvbQk=?= =?utf-8?b?cGtndGVtcF9wcm9iZSgp?=
Date: Fri, 24 Sep 2010 05:02:28 +0000 (UTC)
Message-ID: <loom.20100924T065409-7@post.gmane.org>
References: <4C8E15B30200007800015AC9@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.124.176.202 (Mozilla/5.0 (Windows NT 5.1; rv:2.0b6) Gecko/20100101 Firefox/4.0b6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich <at> novell.com> writes:
> 
> While apparently inherited from coretemp source, this particular error
> handling cleanup path wasn't copied properly (or perhaps got discarded
> intermediately and not re-added properly later).
> 
> Signed-off-by: Jan Beulich <jbeulich <at> novell.com>
> Cc: Fenghua Yu <fenghua.yu <at> intel.com>
> 
> ---
[...]

>  exit_class:
>  	sysfs_remove_group(&pdev->dev.kobj, &pkgtemp_group);
> +exit_dev:
> +	device_remove_file(&pdev->dev, &sensor_dev_attr_temp1_max.dev_attr);
>  exit_free:
>  	kfree(data);
>  exit:
> 
The device file should also be deleted in pkgtemp_remove(). Looks like that got
lost as well.

No need to resend; I'll add that myself.

Guenter


