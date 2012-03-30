Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668Ab2C3UIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:08:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab2C3UIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:08:00 -0400
Date: Sat, 31 Mar 2012 07:07:43 +1100
From: NeilBrown <neilb@suse.de>
To: shuahkhan@gmail.com
Cc: rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120331070743.526de859@notabene.brown>
In-Reply-To: <1333119656.2228.2.camel@lorien2>
References: <1332861697.2834.9.camel@lorien2>
	<20120328104544.593f3d1a@notabene.brown>
	<1332950949.2305.10.camel@lorien2>
	<20120329081109.5e8bbd59@notabene.brown>
	<1332977317.2869.7.camel@lorien2>
	<1333119656.2228.2.camel@lorien2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=KypuLlXAlKLD2NrFxy1s/V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=KypuLlXAlKLD2NrFxy1s/V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Mar 2012 09:00:56 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:

> Neil, Richard,
>=20
> How about this patch? Does this good now? Anything else that=20
> needs attention?

Looks good, thanks.

My only concern is that the first sentence of the doc file reads strangely:

     LED infrastructure lacks support for timer-no-default trigger and
     activation.

It looks like it used to say "timer-one-shot" and you did a search/replace =
on
it.
I think this sentence should mention "one-shot".  "timer-no-default" and
"forever" are how you implement "one-shot" functionality.

Most leds patches seem to be going through Andrew Morton these days.
So if you don't hear anything from anyone else in a couple of day, I suggest
you add
   Reviewed-by: NeilBrown <neilb@suse.de>
   Cc: Richard Purdie <rpurdie@linux.intel.com>

to the 'Signed-off-by: block and mail it to akpm@linux-foundation.org (plea=
se
lkml etc).

NeilBrown


>=20
> Thanks,
> -- Shuah=20
>=20
> On Wed, 2012-03-28 at 17:28 -0600, Shuah Khan wrote:
> > Neil,
> >=20
> > I also added documentation file in this second version. Thanks again for
> > brainstorming ideas and reviews. Leaving the subject line unchanged to
> > avoid confusion, and the documentation and code are updated to change
> > one-shot-timer to timer-no-default.
> >=20
> > >=20
> > > A separate patch is certainly a good idea.
> > > I would do the clean-up patches first, and then have the big change a=
t the
> > > end of the series.  That way checkpatch won't complain about anything=
 in your
> > > change.
> > > But you should do what you are most comfortable with.
> >=20
> > Decided to do the simple_strtoul() cleanup patch later - after this one
> > goes through.
> > >=20
> > > >=20
> > > > >=20
> > > > > > +=09
> > > > >=20
> > > > > Do you need to led_trigger_unregister(&timer_led_trigger) if the =
registration
> > > > > of one_shot_timer_led_trigger fails?
> > > >=20
> > > > Yes, considered that while I was changing this routine, and thought
> > > > might be better to leave the registered timer alone when the second
> > > > registration fails. I can go either way.
> > >=20
> > > The important point is that if timer_trig_init fails, then timer_trig=
_exit
> > > will never be called.
> > > So when timer_trig_init fails, it must ensure that it has un-done any=
 bits
> > > that it successfully did.
> >=20
> > Fixed.
> >=20
> > -- Shuah
> >=20
> > LED infrastructure lacks support for timer-no-default trigger and activ=
ation.
> > The current support allows for setting two timers, one for specifying h=
ow=20
> > long a state to be on, and the second for how long the state to be off.=
 For
> > example, delay_on value specifies the time period an LED should stay in=
 on
> > state, followed by a delay_off value that specifies how long the LED sh=
ould
> > stay in off state. The on and off cycle repeats until the trigger gets=
=20
> > deactivated. There is no provision for one time activation to implement
> > features that require an on or off state to be held just once and then =
stay
> > in the original state forever.
> >=20
> > This feature will help implement vibrate functionality which requires o=
ne
> > time activation of vibrate mode without a continuous vibrate on/off cyc=
les.
> >=20
> > This patch implements the timer-no-default trigger support by enhancing=
 the
> > current led-class, led-core, and ledtrig-timer drivers to
> >=20
> > 1. Add support for forever timer case. forever tag can be written to de=
lay_on
> > or delay_off files. Internally forever is mapped to ULONG_MAX with no t=
imer
> > associated with it.
> >=20
> > 2. The led_blink_set() which takes two pointers to times one each for d=
elay_on
> > and delay_off has been extended so that a NULL instead of a pointer mea=
ns=20
> > "forever".
> >=20
> > 3. Add a new timer-no-default trigger to ledtrig-timer
> >=20
> >=20
> > The above enhancements support the following use-cases:
> >=20
> > use-case 1:
> > echo timer-no-default > /sys/class/leds/SOMELED/trigger
> > echo forever > /sys/class/leds/SOMELED/delay_off
> > echo 2000 > /sys/class/leds/SOMELED/delay_on
> >=20
> > When timer-no-default is activated in step1, unlike the timer trigger c=
ase,
> > timer-no-default activate routine activates the trigger without starting
> > any timers. The default 1 HZ delay_on and delay_off timers won't be sta=
rted
> > like in the case of timer trigger activation. Not starting timers ensur=
es=20
> > that the one time state isn't stuck if some error occurs before actual =
timer
> > periods are specified. delay_on and delay_off files get created with 0
> > values. Please note that it is important to set delay_off to forever pr=
ior
> > to setting delay_on value. If the order is reversed, the LED will be tu=
rned
> > on, with no timer set to turn it off.
> >=20
> > When delay_off value is specified in step 2, delay_off_store recognizes=
 the
> > special forever tag and records it and returns without starting any tim=
er.
> > Internally forever maps to ULONG_MAX. The led_blink_set() which takes
> > two pointers to times one each for delay_on and delay_off has been exte=
nded so
> > that a NULL instead of a pointer means "forever".
> >=20
> > When delay_on value is specified in step 3, a timer gets started for de=
lay_on
> > period, and delay_off stays at ULONG_MAX with no timer associated with =
it.=20
> >=20
> > use-case 2:
> > echo timer-no-default > /sys/class/leds/SOMELED/trigger
> > echo forever > /sys/class/leds/SOMELED/delay_on
> > echo 2000 > /sys/class/leds/SOMELED/delay_off
> >=20
> > When timer-no-default is activated in step1, unlike the timer trigger c=
ase,
> > timer-no-default activate routine activates the trigger without starting
> > any timers. The default 1 HZ delay_on and delay_off timers won't be sta=
rted
> > like in the case of timer trigger activation. Not starting timers ensur=
es=20
> > that the one time state isn't stuck if some error occurs before actual =
timer
> > periods are specified. delay_on and delay_off files get created with 0
> > values. Please note that it is important to set delay_on to forever pri=
or
> > to setting delay_off value. If the order is reversed, the LED will be t=
urned
> > off, with no timer set to turn it back on.
> >=20
> > When delay_on value is specified in step 2, delay_on_store recognizes t=
he
> > special forever tag and records it and returns without starting any tim=
er.=20
> > Internally forever maps to ULONG_MAX.
> >=20
> > When delay_off value is specified in step 3, a timer gets started for d=
elay_off
> > period, and delay_on stays at ULONG_MAX with no timer associated with i=
t.=20
> >=20
> > From f7e8a55fb9ffa10daad1bbb80f2e9e0d81ad359f Mon Sep 17 00:00:00 2001
> > From: Shuah Khan <shuahkhan@gmail.com>
> > Date: Wed, 28 Mar 2012 15:40:33 -0600
> > Subject: [PATCH] LEDS-timer-no-default-implementation
> >=20
> >=20
> > Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> > ---
> >  .../leds/leds-timer_no_default_trigger.txt         |   79 ++++++++++++=
+++
> >  drivers/leds/led-class.c                           |    4 +-
> >  drivers/leds/led-core.c                            |   26 ++++-
> >  drivers/leds/leds.h                                |    2 +
> >  drivers/leds/ledtrig-timer.c                       |  104 ++++++++++++=
++------
> >  5 files changed, 180 insertions(+), 35 deletions(-)
> >  create mode 100644 Documentation/leds/leds-timer_no_default_trigger.txt
> >=20
> > diff --git a/Documentation/leds/leds-timer_no_default_trigger.txt b/Doc=
umentation/leds/leds-timer_no_default_trigger.txt
> > new file mode 100644
> > index 0000000..ff3fdad
> > --- /dev/null
> > +++ b/Documentation/leds/leds-timer_no_default_trigger.txt
> > @@ -0,0 +1,79 @@
> > +
> > +LED timer no default trigger feature (one shot timer)
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > +
> > +LED infrastructure lacks support for timer-no-default trigger and acti=
vation.
> > +The current support allows for setting two timers, one for specifying =
how
> > +long a state to be on, and the second for how long the state to be off=
. For
> > +example, delay_on value specifies the time period an LED should stay i=
n on
> > +state, followed by a delay_off value that specifies how long the LED s=
hould
> > +stay in off state. The on and off cycle repeats until the trigger gets
> > +deactivated. There is no provision for one time activation to implement
> > +features that require an on or off state to be held just once and then=
 stay
> > +in the original state forever.
> > +
> > +This feature will help implement vibrate functionality which requires =
one
> > +time activation of vibrate mode without a continuous vibrate on/off cy=
cles.
> > +
> > +This patch implements the timer-no-default trigger support by enhancin=
g the
> > +current led-class, led-core, and ledtrig-timer drivers to:
> > +
> > +- Add support for forever timer case. forever tag can be written to de=
lay_on
> > +  or delay_off files. Internally forever is mapped to ULONG_MAX with n=
o timer
> > +  associated with it.
> > +
> > +- The led_blink_set() which takes two pointers to times one each for d=
elay_on
> > +  and delay_off has been extended so that a NULL instead of a pointer =
means
> > +  "forever".
> > +
> > +- Add a new timer-no-default trigger to ledtrig-timer
> > +
> > +The above enhancements support the following use-cases:
> > +
> > +use-case 1:
> > +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> > +echo forever > /sys/class/leds/SOMELED/delay_off
> > +echo 2000 > /sys/class/leds/SOMELED/delay_on
> > +
> > +When timer-no-default is activated in step1, unlike the timer trigger =
case,
> > +timer-no-default activate routine activates the trigger without starti=
ng
> > +any timers. The default 1 HZ delay_on and delay_off timers won't be st=
arted
> > +like in the case of timer trigger activation. Not starting timers ensu=
res
> > +that the one time state isn't stuck if some error occurs before actual=
 timer
> > +periods are specified. delay_on and delay_off files get created with 0
> > +values. Please note that it is important to set delay_off to forever p=
rior
> > +to setting delay_on value. If the order is reversed, the LED will be t=
urned
> > +on, with no timer set to turn it off.
> > +
> > +When delay_off value is specified in step 2, delay_off_store recognize=
s the
> > +special forever tag and records it and returns without starting any ti=
mer.
> > +Internally forever maps to ULONG_MAX. The led_blink_set() which takes
> > +two pointers to times one each for delay_on and delay_off has been ext=
ended
> > +so that a NULL instead of a pointer means "forever".
> > +
> > +When delay_on value is specified in step 3, a timer gets started for
> > +delay_on period, and delay_off stays at ULONG_MAX with no timer associ=
ated
> > +with it.
> > +
> > +use-case 2:
> > +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> > +echo forever > /sys/class/leds/SOMELED/delay_on
> > +echo 2000 > /sys/class/leds/SOMELED/delay_off
> > +
> > +When timer-no-default is activated in step1, unlike the timer trigger =
case,
> > +timer-no-default activate routine activates the trigger without starti=
ng
> > +any timers. The default 1 HZ delay_on and delay_off timers won't be st=
arted
> > +like in the case of timer trigger activation. Not starting timers ensu=
res
> > +that the one time state isn't stuck if some error occurs before actual=
 timer
> > +periods are specified. delay_on and delay_off files get created with 0
> > +values. Please note that it is important to set delay_on to forever pr=
ior
> > +to setting delay_off value. If the order is reversed, the LED will be =
turned
> > +off, with no timer set to turn it back on.
> > +
> > +When delay_on value is specified in step 2, delay_on_store recognizes =
the
> > +special forever tag and records it and returns without starting any ti=
mer.
> > +Internally forever maps to ULONG_MAX.
> > +
> > +When delay_off value is specified in step 3, a timer gets started for
> > +delay_off period, and delay_on stays at ULONG_MAX with no timer associ=
ated
> > +with it.
> > diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> > index 5bff843..ed123ba 100644
> > --- a/drivers/leds/led-class.c
> > +++ b/drivers/leds/led-class.c
> > @@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
> > =20
> >  	led_set_brightness(led_cdev, brightness);
> > =20
> > -	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> > +	if (delay !=3D LED_TIMER_FOREVER)
> > +		mod_timer(&led_cdev->blink_timer,
> > +			jiffies + msecs_to_jiffies(delay));
> >  }
> > =20
> >  /**
> > diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> > index d686004..419b0bc 100644
> > --- a/drivers/leds/led-core.c
> > +++ b/drivers/leds/led-core.c
> > @@ -72,17 +72,35 @@ void led_blink_set(struct led_classdev *led_cdev,
> >  		   unsigned long *delay_on,
> >  		   unsigned long *delay_off)
> >  {
> > +	unsigned long val_on;
> > +	unsigned long val_off;
> > +
> >  	del_timer_sync(&led_cdev->blink_timer);
> > =20
> > -	if (led_cdev->blink_set &&
> > +	if (delay_on && delay_off && led_cdev->blink_set &&
> >  	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
> >  		return;
> > =20
> > +	/* if delay_on is null, leave it on forever after delay_off period
> > +	   if delay_off is null, leave it off forever after delay on period */
> > +	if (!delay_on)
> > +		val_on =3D LED_TIMER_FOREVER;
> > +	else
> > +		val_on =3D *delay_on;
> > +
> > +	if (!delay_off)
> > +		val_off =3D LED_TIMER_FOREVER;
> > +	else
> > +		val_off =3D *delay_off;
> > +
> >  	/* blink with 1 Hz as default if nothing specified */
> > -	if (!*delay_on && !*delay_off)
> > -		*delay_on =3D *delay_off =3D 500;
> > +	if (!val_on && !val_off) {
> > +		val_on =3D val_off =3D 500;
> > +		*delay_on =3D 500;
> > +		*delay_off =3D 500;
> > +	}
> > =20
> > -	led_set_software_blink(led_cdev, *delay_on, *delay_off);
> > +	led_set_software_blink(led_cdev, val_on, val_off);
> >  }
> >  EXPORT_SYMBOL(led_blink_set);
> > =20
> > diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
> > index e77c7f8..b2cda9f 100644
> > --- a/drivers/leds/leds.h
> > +++ b/drivers/leds/leds.h
> > @@ -17,6 +17,8 @@
> >  #include <linux/rwsem.h>
> >  #include <linux/leds.h>
> > =20
> > +#define LED_TIMER_FOREVER ULONG_MAX
> > +
> >  static inline void led_set_brightness(struct led_classdev *led_cdev,
> >  					enum led_brightness value)
> >  {
> > diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> > index 328c64c..e323cf2 100644
> > --- a/drivers/leds/ledtrig-timer.c
> > +++ b/drivers/leds/ledtrig-timer.c
> > @@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> > =20
> > +	if (led_cdev->blink_delay_on =3D=3D LED_TIMER_FOREVER)
> > +		return sprintf(buf, "forever\n");
> > +
> >  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
> >  }
> > =20
> > @@ -32,17 +35,25 @@ static ssize_t led_delay_on_store(struct device *de=
v,
> >  {
> >  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> >  	int ret =3D -EINVAL;
> > -	char *after;
> > -	unsigned long state =3D simple_strtoul(buf, &after, 10);
> > -	size_t count =3D after - buf;
> > -
> > -	if (isspace(*after))
> > -		count++;
> > =20
> > -	if (count =3D=3D size) {
> > -		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> > -		led_cdev->blink_delay_on =3D state;
> > -		ret =3D count;
> > +	if (strncmp(buf, "forever", 7) =3D=3D 0) {
> > +		led_blink_set(led_cdev, NULL, &led_cdev->blink_delay_off);
> > +		led_cdev->blink_delay_on =3D LED_TIMER_FOREVER;
> > +		ret =3D size;
> > +	} else {
> > +		char *after;
> > +		unsigned long state =3D simple_strtoul(buf, &after, 10);
> > +		size_t count =3D after - buf;
> > +
> > +		if (isspace(*after))
> > +			count++;
> > +
> > +		if (count =3D=3D size) {
> > +			led_blink_set(led_cdev, &state,
> > +				&led_cdev->blink_delay_off);
> > +			led_cdev->blink_delay_on =3D state;
> > +			ret =3D count;
> > +		}
> >  	}
> > =20
> >  	return ret;
> > @@ -53,6 +64,9 @@ static ssize_t led_delay_off_show(struct device *dev,
> >  {
> >  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> > =20
> > +	if (led_cdev->blink_delay_off =3D=3D LED_TIMER_FOREVER)
> > +		return sprintf(buf, "forever\n");
> > +
> >  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
> >  }
> > =20
> > @@ -61,17 +75,24 @@ static ssize_t led_delay_off_store(struct device *d=
ev,
> >  {
> >  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> >  	int ret =3D -EINVAL;
> > -	char *after;
> > -	unsigned long state =3D simple_strtoul(buf, &after, 10);
> > -	size_t count =3D after - buf;
> > =20
> > -	if (isspace(*after))
> > -		count++;
> > -
> > -	if (count =3D=3D size) {
> > -		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> > -		led_cdev->blink_delay_off =3D state;
> > -		ret =3D count;
> > +	if (strncmp(buf, "forever", 7) =3D=3D 0) {
> > +		led_blink_set(led_cdev, &led_cdev->blink_delay_on, NULL);
> > +		led_cdev->blink_delay_off =3D LED_TIMER_FOREVER;
> > +	} else {
> > +		char *after;
> > +		unsigned long state =3D simple_strtoul(buf, &after, 10);
> > +		size_t count =3D after - buf;
> > +
> > +		if (isspace(*after))
> > +			count++;
> > +
> > +		if (count =3D=3D size) {
> > +			led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> > +				&state);
> > +			led_cdev->blink_delay_off =3D state;
> > +			ret =3D count;
> > +		}
> >  	}
> > =20
> >  	return ret;
> > @@ -80,7 +101,7 @@ static ssize_t led_delay_off_store(struct device *de=
v,
> >  static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_sto=
re);
> >  static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_=
store);
> > =20
> > -static void timer_trig_activate(struct led_classdev *led_cdev)
> > +static void timer_trig_activate_common(struct led_classdev *led_cdev)
> >  {
> >  	int rc;
> > =20
> > @@ -91,17 +112,24 @@ static void timer_trig_activate(struct led_classde=
v *led_cdev)
> >  		return;
> >  	rc =3D device_create_file(led_cdev->dev, &dev_attr_delay_off);
> >  	if (rc)
> > -		goto err_out_delayon;
> > -
> > -	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> > -		      &led_cdev->blink_delay_off);
> > +		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> > =20
> > -	led_cdev->trigger_data =3D (void *)1;
> > +	else
> > +		led_cdev->trigger_data =3D (void *)1;
> > +}
> > =20
> > -	return;
> > +static void timer_trig_activate_timer_no_default(struct led_classdev *=
led_cdev)
> > +{
> > +	timer_trig_activate_common(led_cdev);
> > +}
> > =20
> > -err_out_delayon:
> > -	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> > +static void timer_trig_activate(struct led_classdev *led_cdev)
> > +{
> > +	timer_trig_activate_common(led_cdev);
> > +	if (led_cdev->trigger_data) {
> > +		led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> > +		      &led_cdev->blink_delay_off);
> > +	}
> >  }
> > =20
> >  static void timer_trig_deactivate(struct led_classdev *led_cdev)
> > @@ -121,14 +149,30 @@ static struct led_trigger timer_led_trigger =3D {
> >  	.deactivate =3D timer_trig_deactivate,
> >  };
> > =20
> > +static struct led_trigger timer_no_default_led_trigger =3D {
> > +	.name     =3D "timer-no-default",
> > +	.activate =3D timer_trig_activate_timer_no_default,
> > +	.deactivate =3D timer_trig_deactivate,
> > +};
> > +
> >  static int __init timer_trig_init(void)
> >  {
> > -	return led_trigger_register(&timer_led_trigger);
> > +	int rc =3D 0;
> > +
> > +	rc =3D led_trigger_register(&timer_led_trigger);
> > +	if (!rc) {
> > +		rc =3D led_trigger_register(&timer_no_default_led_trigger);
> > +		if (rc)
> > +			led_trigger_unregister(&timer_led_trigger);
> > +	}
> > +
> > +	return rc;
> >  }
> > =20
> >  static void __exit timer_trig_exit(void)
> >  {
> >  	led_trigger_unregister(&timer_led_trigger);
> > +	led_trigger_unregister(&timer_no_default_led_trigger);
> >  }
> > =20
> >  module_init(timer_trig_init);
>=20


--Sig_/=KypuLlXAlKLD2NrFxy1s/V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3YSjznsnt1WYoG5AQLE9Q//QN9312LgekXGNtveLr287BCuVma1dhQz
lt4+V3RnRcBOtBdeWxVf8BKuGf5oQxiRa0nljE8Ow2B9Zz0BryFMt33t4a3+lAbs
HIxFzPOcmt2Mfzjn4Uu57hE0ihN53DETIQaRV/Ua5Viou959mlMZ4na/rASK3+oV
6H7EgkpgvZrij1XKm2fgx0nbTFm/LbxlcyxErQNHlQj8Wk/sPlUtEfxp4WkEcN35
uUaR+IqOFqJW7hitpRf5m56QrLtjJNcnJYD9Tr8a2DxFrUb5HqQ9i9iSJySskMPr
zQRJZZT70Ci1pW0wdElGlJ84Vk97g1D/Z6Yq0A+alDYsZMNtJVpXMKR/0p0UTi/n
tLwp0FoajzpedGULGJX1qUNs99eDiTZYPdU0y4HhIPBFUNUSDau/tjR+RLlV5/Kj
a58P63KbtU30p9RoCvEN5hwPlihccj6Fw+d6PDHOeoS+SuwnFqiOdM/5oKs5YdPo
DCcgVSO/st3csEKk7DkQ28aKzWbHPI0NFn2ZlE1RAU5ivxvYQZQ5dasLiU+HS6jO
cWKu9gBnSuA1w+mVOLirpng/GnLjmsR3BOKgwV/qLLCK9oQr4b6KO3fO147zAYFt
7l8MQQC8L7YiRw4x72gL9r6tdVSTeH4xRGvUg08Pn+QHtqMYLFoDbb5EbIGBlyoN
pAWGfnxjXm8=
=u9j2
-----END PGP SIGNATURE-----

--Sig_/=KypuLlXAlKLD2NrFxy1s/V--
