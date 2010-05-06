Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab0EFSXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:23:55 -0400
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:35421 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754346Ab0EFSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:23:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=zFyNG+0PhX6uUY1NJ4t8DOe3i/snxVy0ZZgNyuiEjEapaoTCv14Z/+GnudPQAQ4gCY+KazWIipGoCC2ya55b+yDmanDFueJy79dgJ3Sj+RH8rWP3dIrA5TH/rZ9enrQelxXenmDPRej+MEiQx8RX3UixG+YhfVnviyWWBNs2pYc=  ;
X-Yahoo-SMTP: 7VYQSIiswBBpfI3oQQ5mbefGCpOrHbDC5qsO
X-YMail-OSG: 2oOb66wVM1mQLd9akJFH05bWQbngZcKeSrVaGEZZnbKSYZd
 TujfWHsoeleMdet0sdujXtjfEpDBY8cCPkFcePC7x.hG5wYT85tOe8ZSdNyS
 0WzsFA_uYdCLA4QzhmUY.S0JJQ_S2TsZOzGYpeIFo42wZ52TD40fdx484Y2I
 5PcDLdCrbpoSy7kAqduN5eOFRiQVMDxmqKqt2d3E0hiukVh2H2VeuI2tOSNk
 Z4MwG_9GWIrg23nwbSnn0xPHCKBZwhYoA9GV3kX9bREV2s0ZAGZtN7wUM.LB
 mEkY9au8r0oX3VwL8CEakpmhnnCPeF0Lki13m_XXG1f3t87Nr37SGJ4FIfAE
 4Z0AlpG1jWfAvmjgsfZPjV1Dv7YgMjiSM6Ncv5ng5tGd6jt7lyFtdRkI4Wse
 RztKc4X45VXZf4mzhhyyCcOx71PsCgqKHP4eGS58-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BE30935.9040001@yahoo.co.uk>
Date: Thu, 06 May 2010 19:23:49 +0100
From: Don Prince <dhprince.devel@yahoo.co.uk>
Reply-To: dhprince.devel@yahoo.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100422 Mandriva/3.0.4-0.4mdv2010.0 (2010.0) Thunderbird/3.0.4
MIME-Version: 1.0
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2.6.34-rc5] HID: Prodikeys PC-MIDI HID Driver
References: <4BE1A2E2.1040801@yahoo.co.uk> <4BE261FE.60109@ladisch.de>
In-Reply-To: <4BE261FE.60109@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 07:30, Clemens Ladisch wrote:
> dhprince.devel@yahoo wrote:
>   
>> A specialised HID driver for the CreativeLabs Prodikeys PC-MIDI USB 
>> Keyboard.
>> ...
>>     
> I cannot comment on the input stuff, but the sound stuff looks good
> overall.
>   

Thanks my first linux coding.

>   
>> +What:        /sys/bus/hid/drivers/prodikeys/.../channel
>> +Date:        April 2010
>> +KernelVersion:    2.6.34
>> +Contact:    Don Prince <dhprince.devel@yahoo.co.uk>
>> +Descripts/checkpatch.plscription:
>>     
> Huh?
>
>   

Fixed. I am being plagued by spurious button presses due to I suspect
conflicts between
my KVM switch and PS/2 to USB keyboard/Mouse converter.

>> +What:        /sys/bus/hid/drivers/prodikeys/.../sustain
>> +Description:
>> +        Allows control (via software) the sustain duration of a
>> +        note held by the pc-midi driver.
>>     
> Why is this feature needed?  Does the device report key releases
> incorrectly?
>
>   

The keyboard pretends to support sustain. The driver actually does it.

> These three sysfs controls could also be implemented as mixer controls.
> This would allow them to be automatically saved and restored when the
> computer is shut down.
>
>   
>> +    { HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, 
>> USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
>>     
> Your mailer wrapped long lines and killed the tabs.
> Please see <Documentation/email-clients.txt>.
>
> And your code looks as if it does not use eight-column tabs for
> indention.
>
>   

The code is written using 8 column tabs but you are right thunderbird
messed it up. I believe I fixed  thunderbird now.

>> +static void pcmidi_send_note(struct pcmidi_snd *pm,
>> ...
>> +    res = snd_rawmidi_receive(pm->in_substream, buffer, 3);
>>     
> This return value is never used.
>
>   

Fixed.

>> +                    if (!atomic_read(&pms->in_use)) {
>> +                        pms->status = status;
>> +                        pms->note = note;
>> +                        pms->velocity = velocity;
>> +                        atomic_set(&pms->in_use, 1);
>>     
> If you're using the atomic variable to protect against some concurrently
> executing code, then you have a race condition in the time interval
> between the read and the set.
>
>   

Fixed. It was me being overkill, they are actually redundant.

>> +static void pcmidi_out_tasklet(unsigned long data)
>> ...
>> +    while (1) {
>> +        /* just read them and drop them */
>> +        u8 b;
>> +        if (snd_rawmidi_transmit(pm->out_substream, &b, 1) != 1) {
>> +            pm->out_active = 0;
>> +            break;
>> +        }
>>     
> This isn't quite how output ports are supposed to be implemented.  :-)
>
> I'd guess you want to remove the OUTPUT and DUPLEX flags and to drop all
> output-related functions.
>
>   
I know, it was naff, but without it the I get this from "amidi"

$ amidi -l

Dir Device    Name

cannot get rawmidi information 2:0: No such file or directory


Is it supposed to print this?

Although the midi still works.

$ amidi -p hw:2,0 --dump

90 2F 5C

80 2F 7F

90 30 52

80 30 7F

90 32 00

80 32 7F


The test code now looks like this

/*dhp	snd_component_add(card, "MIDI");*/
	err = snd_rawmidi_new(card, card->shortname, 0,
			      0, 1, &rwmidi);
	if (err < 0) {
		pk_error("failed to create pc-midi rawmidi device: error %d\n",
			err);
		goto fail;
	}
	pm->rwmidi = rwmidi;
	strncpy(rwmidi->name, card->shortname, sizeof(rwmidi->name));
	rwmidi->info_flags = SNDRV_RAWMIDI_INFO_INPUT /*dhp|
				SNDRV_RAWMIDI_INFO_OUTPUT |
				SNDRV_RAWMIDI_INFO_DUPLEX*/;
	rwmidi->private_data = pm;

/*dhp	snd_rawmidi_set_ops(rwmidi, SNDRV_RAWMIDI_STREAM_OUTPUT,
		&pcmidi_out_ops);
*/	snd_rawmidi_set_ops(rwmidi, SNDRV_RAWMIDI_STREAM_INPUT,
		&pcmidi_in_ops);


Other command output is printed below.

$ cat /proc/asound/cards

 0 [NVidia         ]: HDA-Intel - HDA NVidia

                      HDA NVidia at 0xdfdf8000 irq 21

 1 [HDMI           ]: HDA-Intel - HDA ATI HDMI

                      HDA ATI HDMI at 0xdffec000 irq 31

 2 [PCMIDI         ]: PC-MIDI - PC-MIDI

                      Prodikeys PC-MIDI Keyboard

$ aconnect -i

client 0: 'System' [type=kernel]

    0 'Timer           '

    1 'Announce        '

client 14: 'Midi Through' [type=kernel]

    0 'Midi Through Port-0'

client 24: 'PC-MIDI' [type=kernel]

    0 'PC-MIDI

$ aconnect -o

client 14: 'Midi Through' [type=kernel]

    0 'Midi Through Port-0'

client 128: 'FLUID Synth (Qsynth1)' [type=user]

    0 'Synth input port (Qsynth1:0)'

$ aconnect -iol

client 0: 'System' [type=kernel]

    0 'Timer           '

    1 'Announce        '

        Connecting To: 15:0

client 14: 'Midi Through' [type=kernel]

    0 'Midi Through Port-0'

client 24: 'PC-MIDI' [type=kernel]

    0 'PC-MIDI         '

        Connecting To: 128:0

client 128: 'FLUID Synth (Qsynth1)' [type=user]

    0 'Synth input port (Qsynth1:0)'

        Connected From: 24:0

$ amidi -L

RawMIDI list:

default {

        type hw

        card {

                @func getenv

                vars {

                        0 ALSA_RAWMIDI_CARD

                        1 ALSA_CARD

                }

                default {

                        @func refer

                        name 'defaults.rawmidi.card'

                }

        }

        device {

                @func igetenv

                vars {

                        0 ALSA_RAWMIDI_DEVICE

                }

                default {

                        @func refer

                        name 'defaults.rawmidi.device'

                }

        }

}

hw {

        @args.0 CARD

        @args.1 DEV

        @args.2 SUBDEV

        @args.CARD {

                type string

                default {

                        @func getenv

                        vars {

                                0 ALSA_RAWMIDI_CARD

                                1 ALSA_CARD

                        }

                        default {

                                @func refer

                                name 'defaults.rawmidi.card'

                        }

                }

        }

        @args.DEV {

                type integer

                default {

                        @func igetenv

                        vars {

                                0 ALSA_RAWMIDI_DEVICE

                        }

                        default {

                                @func refer

                                name 'defaults.rawmidi.device'

                        }

                }

        }

        @args.SUBDEV {

                type integer

                default -1

        }

        type hw

        card $CARD

        device $DEV

        subdevice $SUBDEV

        hint {

                description 'Direct rawmidi driver device'

                device $DEV

        }

}

virtual {

        @args.0 MERGE

        @args.MERGE {

                type string

                default 1

        }

        type virtual

        merge $MERGE

}



>> +static void pcmidi_in_trigger(struct snd_rawmidi_substream *substream, 
>> int up)
>> ...
>> +    if (up)
>> +        set_bit(substream->number, &pm->in_triggered);
>> +    else
>> +        clear_bit(substream->number, &pm->in_triggered);
>>     
> You have only one substream, a boolean variable would suffice.
>   

Fixed.

>   
>> +int pcmidi_snd_initialise(struct pcmidi_snd *pm)
>> ...
>> +    int out_ports = 1;
>> +    int in_ports = 1;
>>     
> These variables are not variable and therefore not needed.
>
>   

Fixed.

>> +    snd_component_add(card, "MIDI");
>>     
> This function is intended for sound cards that are composed of several
> components, and the component name is usually a chip name.  I think
> you don't need to call this function at all.
>
>   

Fixed.

>> +    err = snd_card_register(card);
>> ...
>> +    /* create sysfs variables */
>> +    err = device_create_file(&pm->pk->hdev->dev,
>> +                 sysfs_device_attr_channel);
>> ...
>> +    spin_lock_init(&pm->rawmidi_in_lock);
>> +
>> +    init_sustain_timers(pm);
>>     
> snd_card_register() makes all sound interfaces available to userspace.
> Initializations for any data that might be accessed from userspace must
> be done before that call.
>
>   

Fixed.

> Regards,
> Clemens
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>
>   


		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
