Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1CNO3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:29:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35045 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab1CNO3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <1299990249-18264-2-git-send-email-bgat@billgatliff.com>
References: <1299990249-18264-1-git-send-email-bgat@billgatliff.com>
	<1299990249-18264-2-git-send-email-bgat@billgatliff.com>
Date: Mon, 14 Mar 2011 09:29:00 -0500
Message-ID: <AANLkTim9XhrHjQy8EmGAez6DV8e-aASDHUQOyf=cjvdM@mail.gmail.com>
Subject: Re: [PWM v8 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Bill Gatliff <bgat@billgatliff.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:

On Sat, Mar 12, 2011 at 10:24 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
> +static ssize_t pwm_duty_ns_show(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *buf)
> +{
> +       struct pwm_device *p = to_pwm_device(dev);
> +       return sprintf(buf, "%lu\n", pwm_get_duty_ns(p));
> +}


What would happen if device_unregister() was called on the above
device while duty_ns_show() was running?

My hope is that the device_unregister() would decrement the usage
count on the device, but the count would still be nonzero due to the
running attribute method; thus, the device would not be deleted.  When
the method exited, the usage count would become zero and THEN the
device would disappear.  Is that how things work?  (I have looked at
the code for device_unregister() and friends, but haven't yet been
able to answer this question for myself; said code seems nontrivial).


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
