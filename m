Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab0I0Ovn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:51:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57816 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab0I0Ovm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:organization:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=jif86pKogyow7HCq9iJdzRslLFoGFRMQdyRyaXpM3yoY4kTPUGGIiJdJifYPqiV+4v
         G5P6Pyo9wsp0soCQ9KzWUXmg4KnM0MqEgg5XKnfLt+nl5M5AWTz82DiiuO6hj+w/Ux2Z
         VcDffRt0+WbQMhDNzLyJfh8PrJ+gEzHwHGwpQ=
Message-ID: <4CA0AF77.1080105@laptop.org>
Date: Mon, 27 Sep 2010 10:51:35 -0400
From: "Richard A. Smith" <richard@laptop.org>
Organization: One Laptop per Child
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11pre) Gecko/20100922 Lightning/1.0b2 Shredder/3.1.5pre
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: cbou@mail.ru, dwmw2@infradead.org, dilinger@queued.net,
        linux-kernel@vger.kernel.org, harvey.harrison@gmail.com
Subject: Re: [PATCH v2] olpc_battery: Fix endian neutral breakage for s16
 values
References: <20100925181927.2C3389D401B@zog.reactivated.net>
In-Reply-To: <20100925181927.2C3389D401B@zog.reactivated.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2010 02:19 PM, Daniel Drake wrote:
> From: Richard A. Smith<richard@laptop.org>
>
> When the driver was updated to be endian neutral (8e9c7716c)
> the signed part of the s16 values was lost.  This is because be16_to_cpu()
> returns a signed value.  This patch casts the values back to a s16 number
> prior to the the implicit cast up to an int.

Seems the comment has a error.  Should be 'returns an unsigned' rather 
than signed.  Other than that it looks good.

-- 
Richard A. Smith  <richard@laptop.org>
One Laptop per Child
