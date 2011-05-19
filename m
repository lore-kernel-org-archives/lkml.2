Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902Ab1ESVh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:37:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1ESVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:37:55 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=wom5GMh1gUkA:10 a=Aqo3SY2G75cA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=VnNF1IyMAAAA:8 a=xrmTdKEQcdvIdAnIsz4A:9 a=CjuIK1q_8ugA:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Thu, 19 May 2011 16:37:54 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v5 03/21] evm: re-release
Message-ID: <20110519213754.GA10072@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1305557115-15652-4-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305557115-15652-4-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
...
> +extern int evm_hmac_size;
...
> +int evm_hmac_size = SHA1_DIGEST_SIZE;

I think I object to having both MAX_DIGEST_SIZE and evm_hmac_size, both
of which are set to SHA1_DIGEST_SIZE throughout this patchset.  Especially
because of the comment I was about to make on patch 4/21, where you
then prepend the hmac with a 'type' byte, and start passing around
MAX_DIGEST_SIZE+1 and evm_hmac_size+1.

Even if you're going to be using those differently in a later patchset,
let's focus on this set for now and keep things simpler.  One constant
for the hmac size, and then please define a new one (in patch 4) for
the annotated digest size.  I can't think think of a good name.  Which
suggests that perhaps you should define a nicely typed struct to contain
the header+hmac...

I see no other problems, so presuming that these are nicely addressed
I expect to happily ack.

thanks,
-serge
