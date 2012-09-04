Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2IDFrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 01:47:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21496 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2IDFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 01:47:33 -0400
X-AuditID: cbfee611-b7f836d000003703-70-504595f3d14a
Date: Tue, 04 Sep 2012 05:47:31 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] extcon-max8997: remove usage of ret in
 max8997_muic_handle_charger_type_detach
To: Devendra Naga <develkernel412222@gmail.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120904054602264@myungjoo.ham
Msgkey: 20120904054602264@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120904054602264@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <28012960.171051346737650663.JavaMail.weblogic@epml19>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/tGbqfp7oGGDyYImdxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy3r35zVRwRLhi1vPlrA2MDcJdjJwcQgLqEouWnGQDsSUETCS6
	vnSxQNhiEhfurQeKcwHVzGeUuPR5GStIgkVAReLZ/j3MXYwcHGwCehIzPyeDhIUF0iUOXFjE
	AlIvIrCeUWLLj8fsEAuUJNbsewU2lFdAUOLkzCdQC1Qlnkw9xQ4RV5P4tnIeK0RcQmLW9AtQ
	Nq/EjPanUPVyEtO+rmGGsKUlzs/awAhz6OLvj6Hi/BLHbu9gArkNpPfJ/WCYMbs3f4H6UUBi
	6pmDjBAlWhLXpgdChPkk1ix8ywIzZdep5cwwrfe3zGUCsZkFFCWmdD9kh7C1JL782MeG7ite
	ASeJVQ0T2CYwys5CkpqFpH0WknZkNQsYWVYxiqYWJBcUJ6WnmusVJ+YWl+al6yXn525iBEfz
	M8EdjEsbLA4xCnAwKvHwVn5yCRBiTSwrrsw9xCjBwawkwjsh0zVAiDclsbIqtSg/vqg0J7X4
	EKM0B4uSOO+cF1/8hQTSE0tSs1NTC1KLYLJMHJxSDYxnWidkyt2yfLg1KWHKeRV9C9vIa6bp
	m918WWOeBDkzlh42dOj/7rzD70vpkel/fnrd8xN767f4fJRiCMe+yDkreb5tcKyylFmxuqht
	Rf9Bbqnp819sZTYLcPl7Ve/MGV/t0LCKu2rLd5gmKkrwGVV8jj9uvdX00MOrr5xqwxfI/mAx
	Uby4+5sSS3FGoqEWc1FxIgCoBlvE4gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q845lfxP009211

> any comments ?
> 

Sorry for replying late.

It has been applied to the extcon-for-next tree at
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/extcon-for-next
, which will appear in hours.


> On Wed, Aug 15, 2012 at 12:19 PM, Devendra Naga
> <develkernel412222@gmail.com> wrote:
> > actually we can do returns with error or success with out ret in this function,
> > so remove the ret variable, and reduce a very little (4byte) space on stack of this function
> >
> > Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> > ---
> >  compile tested.
> >
> >  drivers/extcon/extcon-max8997.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> > index ef9090a..77b66b0 100644
> > --- a/drivers/extcon/extcon-max8997.c
> > +++ b/drivers/extcon/extcon-max8997.c
> > @@ -271,8 +271,6 @@ out:
> >  static int max8997_muic_handle_charger_type_detach(
> >                                 struct max8997_muic_info *info)
> >  {
> > -       int ret = 0;
> > -
> >         switch (info->pre_charger_type) {
> >         case MAX8997_CHARGER_TYPE_USB:
> >                 extcon_set_cable_state(info->edev, "USB", false);
> > @@ -290,11 +288,11 @@ static int max8997_muic_handle_charger_type_detach(
> >                 extcon_set_cable_state(info->edev, "Fast-charger", false);
> >                 break;
> >         default:
> > -               ret = -EINVAL;
> > +               return -EINVAL;
> >                 break;
> >         }
> >
> > -       return ret;
> > +       return 0;
> >  }
> >
> >  static int max8997_muic_handle_charger_type(struct max8997_muic_info *info,
> > --
> > 1.7.12.rc2
> >
> 
> 
> 
>        
>   
>          
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
