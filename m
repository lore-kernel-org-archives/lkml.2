Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0INGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:09:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0INGJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=m7iqnyukjfY9/n3u/rm81Nns1WKHYIS4ORt8sqN8CPdqFOz+oBrMWSqs+BsO+k3/yz
         KvCfvyflRIJNZqf+8jRD6MbRU9HWL6tSqkL6tcONXvPZQEM4KK1v0tXsnQzxDyGwoKFD
         MMW9DVK1HCIMPThfdx5qygfDWoc682CgLQJ9Q=
Date: Tue, 14 Sep 2010 06:09:48 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kalle.valo@iki.fi>, Felix Fietkau <nbd@openwrt.org>,
        Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: fix compilation warning
Message-ID: <20100914060948.GA6908@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284441432.3704.0.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-14 07:17, Johannes Berg wrote:
> On Sun, 2010-09-12 at 14:10 +0300, Felipe Contreras wrote:
> 
>>  	struct ieee80211_hdr hdr;
>> -	struct ieee80211s_hdr mesh_hdr;
>>  	const u8 *encaps_data;
>>  	int encaps_len, skip_header_bytes;
>>  	int nh_pos, h_pos;
>> @@ -1755,7 +1754,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>>  		hdrlen = 30;
>>  		break;
>>  #ifdef CONFIG_MAC80211_MESH
>> -	case NL80211_IFTYPE_MESH_POINT:
>> +	case NL80211_IFTYPE_MESH_POINT: {
>> +		struct ieee80211s_hdr mesh_hdr;
>> +
> 
> ...
> 
> might be nicer to just add __maybe_unused.
> 
> johannes
> 

Or at least more consistent with the fix in net-next ;-)

Jarek P.
