Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2HOPKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:10:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51618 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2HOPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:10:23 -0400
Subject: Re: [PATCH] act_mirred: do not drop packets when fails to mirror it
From: Jamal Hadi Salim <jhs@mojatatu.com>
Reply-To: jhs@mojatatu.com
To: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <502BA72B.6070205@redhat.com>
References: <20120815093756.22238.80872.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1345034141.20443.12.camel@mojatatu>  <502BA72B.6070205@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Aug 2012 11:10:19 -0400
Message-ID: <1345043419.3013.8.camel@mojatatu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 21:42 +0800, Jason Wang wrote:

> 
> I met it actually through the following steps:
> 
> - start a kvm guest with tap and make it to be an interface of the bridge
> - mirror the ingress traffic of the bridge to the tap
> - terminate the qemu process, the tap device is then removed
> - all packet goes to bridge would be dropped, so the network of guests 
> in the same bridge would be broken
> 

Makes sense.
Can you please leave the err check braces i.e
        if (err) {
                m->tcf_qstats.overlimits++;
                if (m->tcfm_eaction != TCA_EGRESS_MIRROR)
                        retval = TC_ACT_SHOT;
                else 
                    retval = m->tcf_action;   
        } else {
                retval = m->tcf_action;
        }

Or at least dont use TC_ACT_STOLEN.

cheers,
jamal


