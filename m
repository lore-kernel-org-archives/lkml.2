Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1HZIjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:39:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60116 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1HZIjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:39:44 -0400
Subject: Re: [PATCH 2/2] percpu_counter: Put a reasonable upper bound on
 percpu_counter_batch
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, tj@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110826072927.5b4781f9@kryten>
References: <20110826072622.406d3395@kryten>
	 <20110826072927.5b4781f9@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 10:39:43 +0200
Message-ID: <1314347983.2563.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 août 2011 à 07:29 +1000, Anton Blanchard a écrit :

> +/*
> + * We set the batch at 2 * num_online_cpus(), with a minimum of 32 and
> + * a maximum of 1024.
> + */
>  static void compute_batch_value(void)
>  {
>  	int nr = num_online_cpus();
>  
> -	percpu_counter_batch = max(32, nr*2);
> +	percpu_counter_batch = min(1024, max(32, nr*2));
>  }
>  
>  static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,

Or use the following :

percpu_counter_batch = clamp(nr*2, 32, 1024);



