Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0JYPlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:41:24 -0400
Received: from web37608.mail.mud.yahoo.com ([209.191.87.91]:29412 "HELO
	web37608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754671Ab0JYPlX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:41:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cAcEUSuBAzbh1E8w9Id5I2/4efwHv3UIB3lq1yAaDzzlz5S3qi/QmI4mK4iz296+mzierHNCRlEpaR8zZL8ChkSocp9o8r2/6AkVWwOH9GEBc3adUlL4/IhvoMYjk7yliyAeuhzSooP0MSb/dxLG4KG8MS7EROSPGYVdazPWWYU=;
Message-ID: <254156.53235.qm@web37608.mail.mud.yahoo.com>
X-YMail-OSG: END3WTAVM1m.M3Htt95Cjf.tfdPChWdKExGqYKYzq4YjrBK
 B17fnzclUPTZ3OXo20pAIdjTz2HnGleVPQPMOpiqOWpJbh5JEEyymaDxrN3z
 DVF4pe1a43ZO4pEkZxBNZ38DP3bijh5dpHDbhTuIN3qK0YdQG0QUNtMnfsL0
 C3LbsbBW0BVRDt7QS1BBEu.sjvkkD0TU4LMwIeDqDFxt4Wmw.DyavPqYLMMR
 Lgqwro0ylduH.sNFhzwc0_Pr4.3TMudYVnGRJjVGpdrPW4G6TbfzzwD1LaeA
 lxre3_yLj6jH0mDYQnB9HGPSGS_mEZO28ymA85y6JTLU0GbCzfp.hqe7eLpa
 JXdVmoesOLGR0J8.9n1RakQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:41:20 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 13/29] memstick: core: stop passing pointer to card->current_mrq
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-14-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 13/29] memstick: core: stop passing pointer to card->current_mrq
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This cleans up a lot of code and
> makes the assumption
> (*mrq == &card->current_mrq) official.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---

Unfortunately, the description does not match the patch.
While the main optimization (merging req and card arguments for good) is
fully reasonable given the posterior knowledge of MSPro evolution, this
patch introduces some functional changes as well, which can not be
considered to be a pure cleanup. Some WARN_ONs also appear to be misplaced:

>         if (msb->block_req) {
> -            mspro_block_complete_req(card, (*mrq)->error);
> +            mspro_block_complete_req(card, mrq->error);
>             error = mspro_block_issue_req(card, false);
> 
> -            if (!msb->block_req) {
> +            if (error) {
> +                WARN_ON(msb->block_req);




      
