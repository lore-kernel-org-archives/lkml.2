Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1FNQl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:41:29 -0400
Received: from c60.cesmail.net ([216.154.195.49]:30648 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1FNQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:41:26 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 12:41:26 EDT
Message-ID: <4DF78CEC.70409@gnu.org>
Date: Tue, 14 Jun 2011 12:31:40 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev@vger.kernel.org, Intel Linux Wireless <ilw@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        ath9k-devel@venema.h4ckr.net, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [ath9k-devel] [PATCH net-next 1/2] wireless: Remove casts of
 void *
References: <cover.1308024069.git.joe@perches.com> <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
In-Reply-To: <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 12:02 AM, Joe Perches wrote:

>   		/* Get the message ID */
> -		msg_id = (__be16 *) ((void *) htc_hdr +
> -				     sizeof(struct htc_frame_hdr));
> +		msg_id = (void *)htc_hdr + sizeof(struct htc_frame_hdr);

I would never do stuff like this without verifying by sparse that no 
warnings are introduced.

Sparse warnings should be avoided to keep sparse checks useful. 
Otherwise, important warnings would drown in the noise.

-- 
Regards,
Pavel Roskin
